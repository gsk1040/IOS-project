import SwiftUI

struct User: Codable {
    var id: UUID
    var name: String
    var age: Int
}

//데이터를 자징히고 불러오는 역할
//외부에서 데이터를 변경 해야 하기때문에 참조형으로 선언
class FileManagerHelper {
    // 싱글톤: 이 클래스의 객체는 오직 하나뿐이다.
    // FileManagerHelper.shared.멤버
    static let shared = FileManagerHelper()
    //저장 할 파일 이름
    private let fileName = "users.json"
    
    // JSON 파일로 저장
    func saveUsers(_ users: [User]) {//프로퍼티 안넣고 값생성
        // Document 디렉토리의 경로를 가져옴 (앱 전용 사용자 데이터 저장 경로)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                print("documentDirectory: \(documentDirectory)")
                let fileURL = documentDirectory.appendingPathComponent(fileName)  // 파일 경로 생성

                let encoder = JSONEncoder()  // JSON 인코더 생성
        
    }
    
    // JSON 문자열을 배열로 불러오기
    func loadUsers() -> [User] {
        
    }
}
    
//  FileManagerHelper.swift
//  SwiftUIDay04Ex02FileManager
//
//  Created by 원대한 on 2/13/25.
//

