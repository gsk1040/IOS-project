//
//  ChallengeService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class ChallengeService {
    static let shared = ChallengeService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 도전과제(할일) 생성
    func createChallenge(islandId: String, title: String, description: String?, difficulty: Int, type: Challenge.ChallengeType, dueDate: Date?, completion: @escaping (Result<Challenge, Error>) -> Void) {
        
        // 난이도에 따른 보상 계산
        let reward = calculateReward(difficulty: difficulty, type: type)
        
        let challenge = Challenge(
            islandId: islandId,
            title: title,
            description: description,
            difficulty: difficulty,
            type: type,
            status: .pending,
            dueDate: dueDate,
            reward: reward,
            createdAt: Date()
        )
        
        do {
            let docRef = try db.collection("challenges").addDocument(from: challenge)
            var newChallenge = challenge
            newChallenge.id = docRef.documentID
            completion(.success(newChallenge))
        } catch {
            completion(.failure(error))
        }
    }
    
    // 난이도와 유형에 따른 보상 계산
    private func calculateReward(difficulty: Int, type: Challenge.ChallengeType) -> Challenge.Reward {
        var baseGold = 0
        var baseExp = 0
        
        switch type {
        case .sailor:
            baseGold = 50
            baseExp = 5
        case .pirate:
            baseGold = 100
            baseExp = 10
        case .captain:
            baseGold = 300
            baseExp = 30
        case .legend:
            baseGold = 1000
            baseExp = 100
        }
        
        // 난이도에 따른 보상 배율
        let multiplier = 1.0 + (Double(difficulty) * 0.2)
        
        // 특별 보상 확률 계산 (난이도가 높을수록 희귀 보상 확률 증가)
        let treasureChance = difficulty * 5  // 5%, 10%, 15%, 20%, 25%
        let skillChance = difficulty * 2     // 2%, 4%, 6%, 8%, 10%
        
        // 특별 보상 배열
        var treasures: [String] = []
        var skills: [String] = []
        
        // 난이도 4 이상이면 특별 보물 확률적으로 추가
        if difficulty >= 4 && Int.random(in: 1...100) <= treasureChance {
            treasures.append("treasure_\(Int.random(in: 1...5))")
        }
        
        // 난이도 5면 능력 확률적으로 추가
        if difficulty == 5 && Int.random(in: 1...100) <= skillChance {
            skills.append("skill_\(Int.random(in: 1...3))")
        }
        
        return Challenge.Reward(
            gold: Int(Double(baseGold) * multiplier),
            experience: Int(Double(baseExp) * multiplier),
            treasures: treasures,
            skills: skills
        )
    }
    
    // 섬에 속한 모든 도전과제 가져오기
    func getChallenges(islandId: String, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        db.collection("challenges")
            .whereField("island_id", isEqualTo: islandId)
            .order(by: "created_at")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                do {
                    let challenges = try documents.compactMap { try $0.data(as: Challenge.self) }
                    completion(.success(challenges))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // 특정 도전과제 가져오기
    func getChallenge(challengeId: String, completion: @escaping (Result<Challenge, Error>) -> Void) {
        db.collection("challenges").document(challengeId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let challenge = try snapshot?.data(as: Challenge.self) {
                    completion(.success(challenge))
                } else {
                    completion(.failure(NSError(domain: "ChallengeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Challenge not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // 도전과제 완료 처리
    func completeChallenge(challengeId: String, completion: @escaping (Result<Challenge.Reward, Error>) -> Void) {
        // 트랜잭션을 사용하여 도전과제 완료 및 보상 지급
        db.runTransaction { [weak self] (transaction, errorPointer) -> Any? in
            guard let self = self else { return nil }
            
            // 1. 도전과제 정보 가져오기
            let challengeRef = self.db.collection("challenges").document(challengeId)
            let challengeSnapshot: DocumentSnapshot
            
            do {
                challengeSnapshot = try transaction.getDocument(challengeRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let challengeData = challengeSnapshot.data(),
                  let status = challengeData["status"] as? String,
                  status == Challenge.ChallengeStatus.pending.rawValue,
                  let islandId = challengeData["island_id"] as? String,
                  let rewardData = challengeData["reward"] as? [String: Any],
                  let gold = rewardData["gold"] as? Int,
                  let experience = rewardData["experience"] as? Int else {
                let error = NSError(domain: "ChallengeService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid challenge data or already completed"])
                errorPointer?.pointee = error
                return nil
            }
            
            // 2. 도전과제 완료 처리
            transaction.updateData([
                "status": Challenge.ChallengeStatus.completed.rawValue,
                "completedAt": FieldValue.serverTimestamp()
            ], forDocument: challengeRef)
            
            // 3. 사용자 보상 지급
            guard let userId = AuthService.shared.currentUserId else {
                let error = NSError(domain: "ChallengeService", code: 3, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
                errorPointer?.pointee = error
                return nil
            }
            
            let userRef = self.db.collection("users").document(userId)
            transaction.updateData([
                "gold": FieldValue.increment(Int64(gold)),
                "exp": FieldValue.increment(Int64(experience))
            ], forDocument: userRef)
            
            // 4. 특별 보상 생성 (보물, 능력)
            let treasures = rewardData["treasures"] as? [String] ?? []
            let skills = rewardData["skills"] as? [String] ?? []
            
            if !treasures.isEmpty {
                // 보물 생성 로직 (별도로 구현 필요)
            }
            
            if !skills.isEmpty {
                // 사용자 스킬 추가
                transaction.updateData([
                    "skills": FieldValue.arrayUnion(skills)
                ], forDocument: userRef)
            }
            
            // 5. 섬 진행도 업데이트
            self.updateIslandProgressAfterChallengeCompletion(islandId: islandId)
            
            return rewardData
        } completion: { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let rewardDict = result as? [String: Any],
                  let gold = rewardDict["gold"] as? Int,
                  let experience = rewardDict["experience"] as? Int else {
                completion(.failure(NSError(domain: "ChallengeService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to process reward"])))
                return
            }
            
            let treasures = rewardDict["treasures"] as? [String] ?? []
            let skills = rewardDict["skills"] as? [String] ?? []
            
            let reward = Challenge.Reward(
                gold: gold,
                experience: experience,
                treasures: treasures,
                skills: skills
            )
            
            completion(.success(reward))
        }
    }
    
    // 섬 진행도 업데이트
    private func updateIslandProgressAfterChallengeCompletion(islandId: String) {
        // 모든 도전과제 가져오기
        getChallenges(islandId: islandId) { result in
            switch result {
            case .success(let challenges):
                // 진행도 계산 (완료된 도전과제 / 전체 도전과제)
                let completedCount = challenges.filter { $0.status == .completed }.count
                let totalCount = challenges.count
                let progress = totalCount > 0 ? (Double(completedCount) / Double(totalCount)) * 100.0 : 0.0
                
                // 섬 진행도 업데이트
                IslandService.shared.updateIslandProgress(islandId: islandId, progress: progress) { _ in }
                
                // 모든 도전과제가 완료되면 섬도 완료 처리
                if completedCount == totalCount && totalCount > 0 {
                    // 섬 정보 가져와서 voyage 정보 확인
                    IslandService.shared.getIsland(islandId: islandId) { islandResult in
                        if case .success(let island) = islandResult {
                            IslandService.shared.completeIsland(islandId: islandId, voyageId: island.voyageId) { _ in }
                        }
                    }
                }
            case .failure(let error):
                print("Failed to update island progress: \(error.localizedDescription)")
            }
        }
    }
    
    // 도전과제 삭제
    func deleteChallenge(challengeId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("challenges").document(challengeId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
}