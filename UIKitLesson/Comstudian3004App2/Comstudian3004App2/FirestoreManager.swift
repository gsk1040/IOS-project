//
//  FirestoreManager.swift
//  Comstudian3004App2
//
//  Created by 원대한 on 3/28/25.
//


import FirebaseFirestore

// Firestore 데이터 관리를 위한 싱글톤 클래스
class FirestoreManager {
    // FirestoreManager의 단일 인스턴스 생성 (싱글톤 패턴 적용)
    static let shared = FirestoreManager()
    
    // Firestore 데이터베이스 인스턴스 생성
    private let db = Firestore.firestore()
    
    // "todos" 컬렉션을 사용하여 할 일 데이터를 관리
    private let collection = "todos"

    // Firestore에 할 일 데이터를 추가하는 함수
    func addTodo(title: String, completion: @escaping (Error?) -> Void) {
        // Firestore에서 새로운 문서 ID 자동 생성
        let docRef = db.collection(collection).document()
        // 생성된 ID를 Todo 객체에 포함
        let todo = Todo(id: docRef.documentID, title: title, isCompleted: false)

        do {
            // Firestore에 데이터를 저장 (Codable을 사용하여 Todo 객체를 변환)
            try docRef.setData(from: todo, completion: completion)
        } catch {
            // 데이터 변환 오류가 발생한 경우 에러 콜백 실행
            completion(error)
        }
    }

    // Firestore에서 데이터를 실시간으로 가져오는 함수
    func fetchTodos(completion: @escaping ([Todo]?, Error?) -> Void) {
        db.collection(collection).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                // Firestore에서 데이터를 가져오는 중 오류 발생 시 에러 반환
                completion(nil, error)
                return
            }
            // Firestore의 문서 데이터를 Todo 객체 배열로 변환
            let todos = documents.compactMap { try? $0.data(as: Todo.self) }
            // 변환된 데이터를 콜백으로 반환
            completion(todos, nil)
        }
    }

    // Firestore에서 특정 할 일의 완료 상태를 업데이트하는 함수
    func updateTodo(todo: Todo, completion: @escaping (Error?) -> Void) {
        // 해당 ID의 문서 참조 가져오기
        let docRef = db.collection(collection).document(todo.id)
        // 완료 상태 반전 후 Firestore에 업데이트
        docRef.updateData(["isCompleted": !todo.isCompleted], completion: completion)
    }

    // Firestore에서 특정 할 일을 삭제하는 함수
    func deleteTodo(id: String, completion: @escaping (Error?) -> Void) {
        // 해당 ID의 문서를 Firestore에서 삭제
        db.collection(collection).document(id).delete(completion: completion)
    }
}

