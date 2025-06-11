//
//  LoginView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 로고 및 제목
                VStack(spacing: 16) {
                    Image(systemName: "syringe")
                        .font(.system(size: 60))
                        .foregroundColor(theme.colors.primary)
                    
                    Text("메디스캔")
                        // [오류 수정 완료] theme.typography.Heading().font -> theme.typography.heading
                        .font(theme.typography.heading)
                        .foregroundStyle(theme.colors.textLight)
                    
                    Text("건강검진표를 쉽게 이해하세요")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.caption)
                }
                .padding(.bottom, 40)
                
                // 로그인 폼
                VStack(spacing: 16) {
                    TextField("이메일", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(theme.colors.danger)
                        .font(theme.typography.caption)
                }
                
                Button(action: {
                    authViewModel.signIn(email: email, password: password) { _ in }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("로그인")
                            .font(theme.typography.button)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(theme.colors.primary)
                .cornerRadius(8)
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .padding(.horizontal)

                Button("비밀번호를 잊으셨나요?") { showForgotPassword = true }
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.primary)
                
                Spacer()
                
                HStack {
                    Text("계정이 없으신가요?")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.caption)
                    
                    Button("회원가입") { showSignUp = true }
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.primary)
                }
            }
            .padding()
            .sheet(isPresented: $showSignUp) { SignUpView() }
            .sheet(isPresented: $showForgotPassword) { ForgotPasswordView() }
        }
    }
}
