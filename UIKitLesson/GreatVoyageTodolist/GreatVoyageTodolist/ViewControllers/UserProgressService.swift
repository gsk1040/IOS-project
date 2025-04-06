//
//  UserProgressService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class UserProgressService {
    static let shared = UserProgressService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 경험치 획득 및 레벨업 처리
    func addExperience(experience: Int, completion: @escaping (Result<(newLevel: Int, leveledUp: Bool), Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            completion(.failure(NSError(domain: "UserProgressService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        // 트랜잭션으로 레벨업 처리
        db.runTransaction { [weak self] (transaction, errorPointer) -> Any? in
            guard let self = self else { return nil }
            
            // 1. 사용자 정보 가져오기
            let userRef = self.db.collection("users").document(userId)
            let userSnapshot: DocumentSnapshot
            
            do {
                userSnapshot = try transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let userData = userSnapshot.data(),
                  let currentExp = userData["exp"] as? Int,
                  let currentLevel = userData["level"] as? Int else {
                let error = NSError(domain: "UserProgressService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
                errorPointer?.pointee = error
                return nil
            }
            
            // 2. 새 경험치 계산
            let newExp = currentExp + experience
            
            // 3. 레벨업 체크 (간단한 레벨업 공식: level * 100)
            let expForNextLevel = currentLevel * 100
            let newLevel: Int
            let leveledUp: Bool
            
            if newExp >= expForNextLevel {
                newLevel = currentLevel + 1
                leveledUp = true
                
                // 레벨업 보상 (골드 지급)
                let levelUpReward = newLevel * 100
                transaction.updateData([
                    "level": newLevel,
                    "exp": newExp,
                    "gold": FieldValue.increment(Int64(levelUpReward))
                ], forDocument: userRef)
            } else {
                newLevel = currentLevel
                leveledUp = false
                
                transaction.updateData([
                    "exp": newExp
                ], forDocument: userRef)
            }
            
            return [
                "newLevel": newLevel,
                "leveledUp": leveledUp
            ]
        } completion: { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let resultDict = result as? [String: Any],
                  let newLevel = resultDict["newLevel"] as? Int,
                  let leveledUp = resultDict["leveledUp"] as? Bool else {
                completion(.failure(NSError(domain: "UserProgressService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to process level up"])))
                return
            }
            
            completion(.success((newLevel: newLevel, leveledUp: leveledUp)))
        }
    }
    
    // 골드 획득
    func addGold(gold: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            completion(.failure(NSError(domain: "UserProgressService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        // 현재 골드 가져오기
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = snapshot?.data(),
                  let currentGold = userData["gold"] as? Int else {
                completion(.failure(NSError(domain: "UserProgressService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                return
            }
            
            // 골드 업데이트
            userRef.updateData([
                "gold": FieldValue.increment(Int64(gold))
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(currentGold + gold))
            }
        }
    }
    
    // 스킬 획득
    func addSkill(skill: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            completion(.failure(NSError(domain: "UserProgressService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        // 현재 스킬 가져오기
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = snapshot?.data(),
                  let currentSkills = userData["skills"] as? [String] else {
                completion(.failure(NSError(domain: "UserProgressService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                return
            }
            
            // 이미 가지고 있는 스킬인지 확인
            if currentSkills.contains(skill) {
                completion(.success(currentSkills))
                return
            }
            
            // 스킬 추가
            userRef.updateData([
                "skills": FieldValue.arrayUnion([skill])
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                var updatedSkills = currentSkills
                updatedSkills.append(skill)
                completion(.success(updatedSkills))
            }
        }
    }
}