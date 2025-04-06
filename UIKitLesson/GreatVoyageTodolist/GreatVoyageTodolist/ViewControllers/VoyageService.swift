//
//  VoyageService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class VoyageService {
    static let shared = VoyageService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 대항해(목표) 생성
    func createVoyage(title: String, description: String, completion: @escaping (Result<Voyage, Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            completion(.failure(NSError(domain: "VoyageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let voyage = Voyage(
            userId: userId,
            title: title,
            description: description,
            status: .ongoing,
            progress: 0.0,
            createdAt: Date()
        )
        
        do {
            let docRef = try db.collection("voyages").addDocument(from: voyage)
            var newVoyage = voyage
            newVoyage.id = docRef.documentID
            completion(.success(newVoyage))
        } catch {
            completion(.failure(error))
        }
    }
    
    // 사용자의 모든 대항해 가져오기
    func getVoyages(completion: @escaping (Result<[Voyage], Error>) -> Void) {
        guard let userId = AuthService.shared.currentUserId else {
            let error = NSError(domain: "VoyageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
            print("VoyageService Error: \(error.localizedDescription)") // 로그인 안됨 오류 로그 추가
            completion(.failure(error))
            return
        }
        
        print("VoyageService: Fetching voyages for user ID: \(userId)") // 사용자 ID 로그 추가

        db.collection("voyages")
            .whereField("user_id", isEqualTo: userId) // Firestore의 필드 이름이 'user_id'인지 확인!
            .order(by: "created_at", descending: true) // Firestore의 필드 이름이 'created_at'이고 Timestamp 타입인지 확인!
            .getDocuments { snapshot, error in
                if let error = error {
                    // Firestore 쿼리 자체에서 에러 발생 시 (인덱스 문제 등)
                    print("VoyageService Error fetching documents: \(error.localizedDescription)")
                    // Firestore가 인덱스 생성을 제안하는 에러 메시지인지 확인하세요. (Xcode 콘솔)
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("VoyageService: No documents found.") // 문서 없음 로그 추가
                    completion(.success([]))
                    return
                }
                
                print("VoyageService: Fetched \(documents.count) documents.") // 가져온 문서 개수 로그 추가

                do {
                    // Firestore 문서를 Voyage 객체로 디코딩 시도
                    let voyages = try documents.compactMap { document -> Voyage? in
                        do {
                            // 각 문서를 Voyage 객체로 디코딩 시도
                            let voyage = try document.data(as: Voyage.self)
                            print("VoyageService: Successfully decoded voyage - ID: \(voyage.id ?? "N/A"), Title: \(voyage.title)") // 성공 로그 추가
                            return voyage
                        } catch {
                            // 특정 문서 디코딩 실패 시 오류 로그 출력 (데이터 구조 문제 확인 가능)
                            print("VoyageService Error decoding document \(document.documentID): \(error)")
                            return nil // 디코딩 실패한 문서는 건너뜀
                        }
                    }
                    print("VoyageService: Successfully decoded \(voyages.count) voyages.") // 최종 디코딩 성공 개수 로그
                    completion(.success(voyages))
                } catch {
                    // compactMap 자체에서 오류가 발생할 경우는 거의 없지만, 대비용
                    print("VoyageService Error during compactMap processing: \(error)")
                    completion(.failure(error))
                }
            }
    }
    // 특정 대항해 가져오기
    func getVoyage(voyageId: String, completion: @escaping (Result<Voyage, Error>) -> Void) {
        db.collection("voyages").document(voyageId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let voyage = try snapshot?.data(as: Voyage.self) {
                    completion(.success(voyage))
                } else {
                    completion(.failure(NSError(domain: "VoyageService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Voyage not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // 대항해 상태 업데이트
    func updateVoyageStatus(voyageId: String, status: Voyage.VoyageStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        var data: [String: Any] = [
            "status": status.rawValue
        ]
        
        if status == .completed {
            data["completed_at"] = FieldValue.serverTimestamp()
        }
        
        db.collection("voyages").document(voyageId).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // 대항해 진행도 업데이트
    func updateVoyageProgress(voyageId: String, progress: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("voyages").document(voyageId).updateData([
            "progress": progress
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // 대항해 삭제
    func deleteVoyage(voyageId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("voyages").document(voyageId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
}
