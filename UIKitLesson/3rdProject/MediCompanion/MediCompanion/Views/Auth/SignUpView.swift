//
//  SignUpView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Views/Auth/SignUpView.swift
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 제목
                Text("계정 만들기")
                    .font(AppTheme.Typography.Heading().font)
                    .foregroundStyle(theme.colors.textLight)
                    .padding(.top, 30)
                
                // 회원가입 폼
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
                    
                    SecureField("비밀번호 확인", text: $confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // 오류 메시지
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(theme.colors.danger)
                        .font(AppTheme.Typography.Caption().font)
                        .padding(.top, 8)
                }
                
                // 회원가입 버튼
                Button(action: {
                    signUp()
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("회원가입")
                            .font(AppTheme.Typography.Button().font)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(theme.colors.primary)
                .cornerRadius(8)
                .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || authViewModel.isLoading)
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(theme.colors.textLight)
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    private func signUp() {
        // 입력값 검증
        if !isValidEmail(email) {
            alertTitle = "이메일 오류"
            alertMessage = "유효한 이메일 주소를 입력해주세요."
            showAlert = true
            return
        }
        
        if password.count < 6 {
            alertTitle = "비밀번호 오류"
            alertMessage = "비밀번호는 최소 6자리 이상이어야 합니다."
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertTitle = "비밀번호 불일치"
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }
        
        // 회원가입 처리
        authViewModel.signUp(email: email, password: password) { success in
            if success {
                dismiss()
            }
        }
    }
    
    // 이메일 유효성 검사
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
