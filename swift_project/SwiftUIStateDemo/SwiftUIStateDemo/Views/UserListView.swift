//
//  UserViewModel.swift
//  SwiftUIStateDemo
//
//  Created by 원대한 on 3/28/25.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var newName: String = ""
    

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // 입력 필드
                TextField("이름을 입력하세요", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 추가 버튼
                Button("이름 추가") {
                    guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.addUser(name: newName)
                    newName = ""
                }
                .padding()
                
                // 사용자 리스트 표시
                List{
                    ForEach(viewModel.users) { user in
                        Text(user.username)
                    }
                    .onDelete(perform: viewModel.deleteUser) // 삭제 기능 추가
                }
                .listStyle(PlainListStyle()) // 보기 좋게
            }
            .navigationTitle("사용자 목록")
            .toolbar {
                EditButton() // 삭제 활성화 버튼
            }
        }
    }
}

