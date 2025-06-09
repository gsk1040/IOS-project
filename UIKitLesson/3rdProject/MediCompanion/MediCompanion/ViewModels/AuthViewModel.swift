//
//  AuthViewModel.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// ViewModels/AuthViewModel.swift
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var db = Firestore.firestore()
    
    init() {
        // 앱 시작 시 자동 로그인 처리
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            self.isLoading = true
            fetchUserData(userId: firebaseUser.uid)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                
                if let userId = result?.user.uid {
                    self.fetchUserData(userId: userId, completion: completion)
                } else {
                    self.errorMessage = "알 수 없는 오류가 발생했습니다."
                    completion(false)
                }
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                
                if let userId = result?.user.uid {
                    // 새 사용자 데이터 생성
                    let newUser = User(id: userId, email: email)
                    self.createUserRecord(user: newUser, completion: completion)
                } else {
                    self.isLoading = false
                    self.errorMessage = "계정 생성 중 오류가 발생했습니다."
                    completion(false)
                }
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            errorMessage = "로그아웃 중 오류가 발생했습니다."
        }
    }
    
    private func createUserRecord(user: User, completion: @escaping (Bool) -> Void) {
        let userData: [String: Any] = [
            "email": user.email,
            "remainingScans": user.remainingScans,
            "isPremium": user.isPremium,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(user.id).setData(userData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "사용자 데이터 저장 중 오류: \(error.localizedDescription)"
                    completion(false)
                    return
                }
                
                self.user = user
                self.isAuthenticated = true
                completion(true)
            }
        }
    }
    
    private func fetchUserData(userId: String, completion: ((Bool) -> Void)? = nil) {
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion?(false)
                    return
                }
                
                if let data = snapshot?.data(),
                   let email = data["email"] as? String {
                    let remainingScans = data["remainingScans"] as? Int ?? 3
                    let isPremium = data["isPremium"] as? Bool ?? false
                    
                    let user = User(id: userId, email: email, remainingScans: remainingScans, isPremium: isPremium)
                    self.user = user
                    self.isAuthenticated = true
                    completion?(true)
                } else {
                    self.errorMessage = "사용자 정보를 찾을 수 없습니다."
                    completion?(false)
                }
            }
        }
    }
    
    func useFreeScan() {
        guard var currentUser = user, !currentUser.isPremium, currentUser.remainingScans > 0 else { return }
        
        currentUser.remainingScans -= 1
        user = currentUser
        
        // Firestore 업데이트
        db.collection("users").document(currentUser.id).updateData([
            "remainingScans": currentUser.remainingScans
        ]) { [weak self] error in
            if let error = error {
                self?.errorMessage = "스캔 사용 업데이트 중 오류: \(error.localizedDescription)"
            }
        }
    }
}