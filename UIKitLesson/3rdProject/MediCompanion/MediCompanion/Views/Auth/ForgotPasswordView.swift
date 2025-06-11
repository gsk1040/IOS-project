//
//  ForgotPasswordView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Views/Auth/ForgotPasswordView.swift
import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 제목
                Text("비밀번호 재설정")
                    // [오류 수정 완료] .font(AppTheme.Typography.Heading().font) -> .font(theme.typography.heading)
                    .font(theme.typography.heading)
                    .foregroundStyle(theme.colors.textLight)
                    .padding(.top, 30)
                
                Text("가입하신 이메일로 비밀번호 재설정 링크를 보내드립니다.")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 이메일 입력 필드
                TextField("이메일", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // 오류 메시지
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(theme.colors.danger)
                        .font(theme.typography.caption)
                        .padding(.top, 8)
                }
                
                // 전송 버튼
                Button(action: {
                    resetPassword()
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("재설정 링크 전송")
                            .font(theme.typography.button)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(theme.colors.primary)
                .cornerRadius(8)
                .disabled(email.isEmpty || authViewModel.isLoading)
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
                dismissButton: .default(Text("확인")) {
                    if alertTitle == "이메일 전송 완료" {
                        dismiss()
                    }
                }
            )
        }
    }
    
    private func resetPassword() {
        authViewModel.resetPassword(email: email) { success in
            if success {
                alertTitle = "이메일 전송 완료"
                alertMessage = "비밀번호 재설정 링크가 이메일로 전송되었습니다."
            } else {
                alertTitle = "오류 발생"
                alertMessage = authViewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다."
            }
            showAlert = true
        }
    }
}
