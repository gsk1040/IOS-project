//
//  LoginView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Views/Auth/LoginView.swift
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
                        .padding()
                    
                    Text("메디스캔")
                        .font(AppTheme.Typography.Heading().font)
                        .foregroundStyle(theme.colors.textLight)
                    
                    Text("건강검진표를 쉽게 이해하세요")
                        .font(AppTheme.Typography.Body().font)
                        .foregroundStyle(theme.colors.caption)
                }
                .padding(.bottom, 40)
                
                // 로그인 폼
                VStack(spacing: 16) {
                    TextField("이메일", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // 오류 메시지
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(theme.colors.danger)
                        .font(AppTheme.Typography.Caption().font)
                        .padding(.top, 8)
                }
                
                // 로그인 버튼
                Button(action: {
                    authViewModel.signIn(email: email, password: password) { success in
                        // 성공 시 처리는 ContentView에서 관리
                    }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("로그인")
                            .font(AppTheme.Typography.Button().font)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(theme.colors.primary)
                .cornerRadius(8)
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .padding(.horizontal)
                .padding(.top, 10)
                
                // 비밀번호 찾기
                Button("비밀번호를 잊으셨나요?") {
                    showForgotPassword = true
                }
                .font(AppTheme.Typography.Caption().font)
                .foregroundColor(theme.colors.primary)
                .padding(.top, 8)
                
                Spacer()
                
                // 회원가입 버튼
                HStack {
                    Text("계정이 없으신가요?")
                        .font(AppTheme.Typography.Caption().font)
                        .foregroundColor(theme.colors.caption)
                    
                    Button("회원가입") {
                        showSignUp = true
                    }
                    .font(AppTheme.Typography.Caption().font)
                    .foregroundColor(theme.colors.primary)
                }
                .padding(.bottom, 20)
            }
            .padding(.vertical, 30)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}
