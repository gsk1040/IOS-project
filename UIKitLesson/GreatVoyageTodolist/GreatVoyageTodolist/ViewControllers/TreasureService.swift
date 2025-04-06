//
//  TreasureService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class TreasureService {
    static let shared = TreasureService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 보물 생성
    func createTreasure(userId: String, name: String, description: String, rarity: Treasure.TreasureRarity, imageUrl: String, source: String, completion: @escaping (Result<Treasure, Error>) -> Void) {
        let treasure = Treasure(
            userId: userId,
            name: name,
            description: description,
            rarity: rarity,
            imageUrl: imageUrl,
            acquiredAt: Date(),
            source: source
        )
        
        do {
            let docRef = try db.collection("treasures").addDocument(from: treasure)
            var newTreasure = treasure
            newTreasure.id = docRef.documentID
            completion(.success(newTreasure))
        } catch {
            completion(.failure(error))
        }
    }
    
    // 사용자의 모든 보물 가져오기
    func getTreasures(completion: @escaping (Result<[Treasure], Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            completion(.failure(NSError(domain: "TreasureService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        db.collection("treasures")
            .whereField("user_id", isEqualTo: userId)
            .order(by: "acquired_at", descending: true)
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
                    let treasures = try documents.compactMap { try $0.data(as: Treasure.self) }
                    completion(.success(treasures))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // 특정 보물 가져오기
    func getTreasure(treasureId: String, completion: @escaping (Result<Treasure, Error>) -> Void) {
        db.collection("treasures").document(treasureId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let treasure = try snapshot?.data(as: Treasure.self) {
                    completion(.success(treasure))
                } else {
                    completion(.failure(NSError(domain: "TreasureService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Treasure not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // 도전과제 완료시 보물 부여
    func awardTreasureForChallenge(challengeId: String, completion: @escaping (Result<Treasure?, Error>) -> Void) {
        // 1. 도전과제 정보 가져오기
        ChallengeService.shared.getChallenge(challengeId: challengeId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let challenge):
                // 2. 보물이 있는지 확인
                guard let treasureId = challenge.reward.treasures.first else {
                    // 보물이 없으면 nil 반환
                    completion(.success(nil))
                    return
                }
                
                // 3. 사용자 확인
                guard let userId = AuthService.shared.currentUserId else {
                    completion(.failure(NSError(domain: "TreasureService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
                    return
                }
                
                // 4. 보물 타입에 따른 정보 설정
                let (name, description, rarity, imageUrl) = self.getTreasureInfo(treasureId: treasureId)
                
                // 5. 보물 생성
                self.createTreasure(
                    userId: userId,
                    name: name,
                    description: description,
                    rarity: rarity,
                    imageUrl: imageUrl,
                    source: "challenge_\(challengeId)"
                ) { treasureResult in
                    completion(treasureResult.map { $0 })
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 보물 ID에 따른 정보 반환
    private func getTreasureInfo(treasureId: String) -> (name: String, description: String, rarity: Treasure.TreasureRarity, imageUrl: String) {
        // 실제 구현에서는 보물 템플릿 DB나 설정에서 가져와야 함
        // 여기서는 간단히 하드코딩
        let rarityValue = Int(treasureId.split(separator: "_").last ?? "1") ?? 1
        let rarity: Treasure.TreasureRarity
        
        switch rarityValue {
        case 1: rarity = .common
        case 2: rarity = .uncommon
        case 3: rarity = .rare
        case 4: rarity = .epic
        case 5: rarity = .legendary
        default: rarity = .common
        }
        
        return (
            name: "전설의 보물 #\(rarityValue)",
            description: "위대한 항해에서 발견한 귀중한 보물입니다.",
            rarity: rarity,
            imageUrl: "treasure_\(rarityValue).png"
        )
    }
}
