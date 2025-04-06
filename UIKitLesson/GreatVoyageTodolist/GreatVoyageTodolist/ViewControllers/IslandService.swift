//
//  IslandService.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class IslandService {
    static let shared = IslandService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 섬(체크포인트) 생성
    func createIsland(voyageId: String, title: String, description: String, coordinates: [String: Double], completion: @escaping (Result<Island, Error>) -> Void) {
        // 현재 섬의 순서 가져오기
        db.collection("islands")
            .whereField("voyage_id", isEqualTo: voyageId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let currentOrder = snapshot?.documents.count ?? 0
                
                // 첫 번째 섬이면 상태를 current로 설정
                let status: Island.IslandStatus = currentOrder == 0 ? .current : .locked
                
                let island = Island(
                    voyageId: voyageId,
                    title: title,
                    description: description,
                    order: currentOrder,
                    status: status,
                    progress: 0.0,
                    coordinates: coordinates
                )
                
                do {
                    let docRef = try self.db.collection("islands").addDocument(from: island)
                    var newIsland = island
                    newIsland.id = docRef.documentID
                    completion(.success(newIsland))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // 대항해에 속한 모든 섬 가져오기
    func getIslands(voyageId: String, completion: @escaping (Result<[Island], Error>) -> Void) {
        db.collection("islands")
            .whereField("voyage_id", isEqualTo: voyageId)
            .order(by: "order")
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
                    let islands = try documents.compactMap { try $0.data(as: Island.self) }
                    completion(.success(islands))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // 특정 섬 가져오기
    func getIsland(islandId: String, completion: @escaping (Result<Island, Error>) -> Void) {
        db.collection("islands").document(islandId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let island = try snapshot?.data(as: Island.self) {
                    completion(.success(island))
                } else {
                    completion(.failure(NSError(domain: "IslandService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Island not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // 섬 상태 업데이트
    func updateIslandStatus(islandId: String, status: Island.IslandStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("islands").document(islandId).updateData([
            "status": status.rawValue
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // 섬 진행도 업데이트
    func updateIslandProgress(islandId: String, progress: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("islands").document(islandId).updateData([
            "progress": progress
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    
    // 이전 코드에서 계속...
    
    // 섬 완료 처리 및 다음 섬 활성화
    func completeIsland(islandId: String, voyageId: String, completion: @escaping (Result<Island?, Error>) -> Void) {
        // 현재 섬 완료 처리
        db.collection("islands").document(islandId).updateData([
            "status": Island.IslandStatus.completed.rawValue,
            "progress": 100.0
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 완료된 섬의 순서 가져오기
            self.getIsland(islandId: islandId) { result in
                switch result {
                case .success(let island):
                    // 다음 섬 찾기
                    let nextOrder = island.order + 1
                    
                    self.db.collection("islands")
                        .whereField("voyage_id", isEqualTo: voyageId)
                        .whereField("order", isEqualTo: nextOrder)
                        .limit(to: 1)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            
                            // 다음 섬이 있으면 활성화
                            if let nextIslandDoc = snapshot?.documents.first {
                                let nextIslandId = nextIslandDoc.documentID
                                
                                self.db.collection("islands").document(nextIslandId).updateData([
                                    "status": Island.IslandStatus.current.rawValue
                                ]) { error in
                                    if let error = error {
                                        completion(.failure(error))
                                        return
                                    }
                                    
                                    // 활성화된 다음 섬 정보 반환
                                    self.getIsland(islandId: nextIslandId) { nextIslandResult in
                                        switch nextIslandResult {
                                        case .success(let nextIsland):
                                            completion(.success(nextIsland))
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
                                }
                            } else {
                                // 다음 섬이 없으면 대항해 진행도 업데이트
                                self.updateVoyageProgress(voyageId: voyageId)
                                completion(.success(nil))
                            }
                        }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 대항해 진행도 업데이트
    private func updateVoyageProgress(voyageId: String) {
        // 모든 섬 가져오기
        getIslands(voyageId: voyageId) { result in
            switch result {
            case .success(let islands):
                // 진행도 계산 (완료된 섬 / 전체 섬)
                let completedCount = islands.filter { $0.status == .completed }.count
                let totalCount = islands.count
                let progress = totalCount > 0 ? (Double(completedCount) / Double(totalCount)) * 100.0 : 0.0
                
                // 대항해 진행도 업데이트
                VoyageService.shared.updateVoyageProgress(voyageId: voyageId, progress: progress) { _ in }
                
                // 모든 섬이 완료되면 대항해도 완료 처리
                if completedCount == totalCount {
                    VoyageService.shared.updateVoyageStatus(voyageId: voyageId, status: .completed) { _ in }
                }
            case .failure(let error):
                print("Failed to update voyage progress: \(error.localizedDescription)")
            }
        }
    }
}
