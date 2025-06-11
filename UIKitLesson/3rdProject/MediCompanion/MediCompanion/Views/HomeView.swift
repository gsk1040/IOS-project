import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack {
                Text("메디스캔")
                    .font(theme.typography.heading)
                
                Text("\"검진표를 촬영하면 쉽게 설명해드려요\"")
                    .font(theme.typography.body)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(colorScheme == .dark ? theme.colors.textDark : theme.colors.textLight)
            
            Image(systemName: "syringe.fill")
                .font(.system(size: 80))
                .foregroundColor(theme.colors.primary)
            
            Spacer()
            
            // [오류 수정 완료] .font() 수정자를 if-else 블록 밖이 아닌,
            // 각 Text 뷰 내부에 개별적으로 적용합니다.
            if let user = authViewModel.user {
                Text("환영합니다, \(user.email)님")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.caption)
            } else {
                Text("로그인이 필요합니다")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.caption)
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    if let user = authViewModel.user {
                        if user.isPremium || user.remainingScans > 0 {
                            appState.navigateTo(.camera)
                        } else {
                            appState.navigateTo(.subscription)
                        }
                    } else {
                        appState.navigateTo(.login)
                    }
                }) {
                    Label("촬영하기", systemImage: "camera")
                        .font(theme.typography.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .accessibilityLabel("촬영하기 버튼")
                
                Button(action: {
                    appState.navigateTo(.chat)
                }) {
                    Label("건강 도우미와 대화하기", systemImage: "bubble.left.and.bubble.right.fill")
                        .font(theme.typography.button)
                        .foregroundColor(theme.colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.colors.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .accessibilityLabel("건강 도우미와 대화하기 버튼")
            }
            
            if let user = authViewModel.user, !user.isPremium {
                Text("남은 무료 스캔: \(user.remainingScans)회")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.caption)
                    .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? theme.colors.backgroundDark : theme.colors.backgroundLight)
    }
}
