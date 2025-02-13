//
//  ContentView.swift
//  SwiftUIDay04Ex01Practice01
//
//  Created by 원대한 on 2/13/25.
//

import SwiftUI

struct UserNameView: View {
    @AppStorage("userName") private var userName: String = "Guest"

    var body: some View {
        VStack {
            Text("안녕하세요, \($userName)님!")
                .font(.title)
                .padding()

            TextField("사용자 이름 입력", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

#Preview {
    UserNameView()
}
