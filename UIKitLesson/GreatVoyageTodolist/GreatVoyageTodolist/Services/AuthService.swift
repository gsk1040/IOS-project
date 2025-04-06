//
//  AuthService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


class AuthService {
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 현재 사용자 ID 가져오기
    var currentUserId: String? {
        return auth.currentUser?.uid
    }
    
    // 회원가입
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                completion(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
                return
            }
            
            let user = User(
                id: authResult.user.uid,
                email: email,
                username: username,
                gold: 100,  // 초기 골드
                level: 1,
                experience: 0,
                skills: [],
                createdAt: Date()
            )
            
            do {
                try self.db.collection("users").document(authResult.user.uid).setData(from: user)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // 로그인
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
                return
            }
            
            self.db.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    if let user = try document?.data(as: User.self) {
                        completion(.success(user))
                    } else {
                        completion(.failure(NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 로그아웃
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // 현재 사용자 정보 가져오기
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = currentUserId else {
            completion(.failure(NSError(domain: "AuthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let user = try document?.data(as: User.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
