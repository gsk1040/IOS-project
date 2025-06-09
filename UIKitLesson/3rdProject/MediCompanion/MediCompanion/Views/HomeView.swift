import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("메디스캔")
                .font(AppTheme.Typography.Heading().font)
                .foregroundStyle(colorScheme == .dark ? theme.colors.textDark : theme.colors.textLight)
                .padding(.bottom, 16)
            
            Image(systemName: "syringe")
                .font(.system(size: 80))
                .foregroundColor(theme.colors.primary)
                .padding(.bottom, 24)
            
            Text("\"검진표를 촬영하면\n쉽게 설명해드려요\"")
                .font(AppTheme.Typography.Body().font)
                .foregroundStyle(colorScheme == .dark ? theme.colors.textDark : theme.colors.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(AppTheme.Typography.Body().lineHeight - AppTheme.Typography.Body().fontSize) // Fixed
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            
            // 사용자 정보 표시
            if let user = authViewModel.user {
                Text("환영합니다, \(user.email)님")
                    .font(AppTheme.Typography.Body().font) // Consistent theme
                    .foregroundStyle(theme.colors.caption)
                    .padding(.bottom, 16)
            } else {
                Text("로그인이 필요합니다") // Feedback for unauthenticated users
                    .font(AppTheme.Typography.Body().font)
                    .foregroundStyle(theme.colors.caption)
                    .padding(.bottom, 16)
            }
            
            Button(action: {
                if let user = authViewModel.user {
                    if user.isPremium || user.remainingScans > 0 {
                        appState.navigateTo(.camera)
                    } else {
                        appState.navigateTo(.subscription)
                    }
                } else {
                    appState.navigateTo(.login) // 이제 유효한 case
                }
            }) {
                HStack {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .padding(.trailing, 8)
                    
                    Text("촬영하기")
                        .font(AppTheme.Typography.Button().font) // Consistent theme
                }
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .background(theme.colors.primary)
                .cornerRadius(8)
            }
            .accessibilityLabel("촬영하기 버튼") // Accessibility
            .padding(.bottom, 16)
            
            Button(action: {
                appState.navigateTo(.chat)
            }) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 20))
                        .padding(.trailing, 8)
                    
                    Text("건강 도우미와 대화하기")
                        .font(AppTheme.Typography.Button().font) // Consistent theme
                }
                .foregroundColor(theme.colors.primary)
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .background(theme.colors.primary.opacity(0.1))
                .cornerRadius(8)
            }
            .accessibilityLabel("건강 도우미와 대화하기 버튼") // Accessibility
            .padding(.bottom, 16)
            
            if let user = authViewModel.user, !user.isPremium {
                Text("남은 무료 스캔: \(user.remainingScans)회")
                    .font(AppTheme.Typography.Caption().font) // Consistent theme
                    .foregroundColor(theme.colors.caption)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? theme.colors.backgroundDark : theme.colors.backgroundLight)
    }
}
