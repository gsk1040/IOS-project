//
//  UserViewModel.swift
//  SwiftUIStateDemo
//
//  Created by 원대한 on 3/28/25.
//


import Foundation
import Combine

class UserViewModel: ObservableObject {
    // 사용자 이름 리스트 저장
    @Published private(set) var users: [UserData] = []
    
    // 텍스트 필드에서 입력된 이름을 받아 배열에 추가
    func addUser(name: String) {
        let newUser = UserData(username: name)
        users.append(newUser)
    }
    
    // 삭제 기능 추가
    func deleteUser(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}
