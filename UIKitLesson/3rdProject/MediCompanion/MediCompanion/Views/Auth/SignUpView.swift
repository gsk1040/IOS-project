//
//  SignUpView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("계정 만들기")
                    // [오류 수정 완료] theme.typography.Heading().font -> theme.typography.heading
                    .font(theme.typography.heading)
                    .foregroundStyle(theme.colors.textLight)
                    .padding(.top, 30)
                
                VStack(spacing: 16) {
                    TextField("이메일", text: $email).keyboardType(.emailAddress).autocapitalization(.none)
                    SecureField("비밀번호", text: $password)
                    SecureField("비밀번호 확인", text: $confirmPassword)
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage).foregroundColor(theme.colors.danger).font(theme.typography.caption)
                }
                
                Button(action: signUp) {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("회원가입")
                            .font(theme.typography.button)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity).padding().background(theme.colors.primary).cornerRadius(8)
                .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || authViewModel.isLoading)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
            })
            .alert("알림", isPresented: $showAlert) {
                Button("확인") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func signUp() {
        if password != confirmPassword {
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }
        authViewModel.signUp(email: email, password: password) { success in
            if success { dismiss() }
        }
    }
}
