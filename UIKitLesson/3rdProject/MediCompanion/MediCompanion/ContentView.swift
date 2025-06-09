// ContentView.swift (업데이트)
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // 인증된 사용자용 메인 화면
                MainAppView()
            } else {
                // 로그인 화면
                LoginView()
            }
        }
    }
}

// 인증 후 메인 앱 구조
struct MainAppView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack(path: $appState.navigationPath) {
            HomeView()
                .navigationDestination(for: AppScreen.self) { screen in
                    switch screen {
                    case .home:
                        HomeView()
                    case .camera:
                        CameraView()
                    case .processing:
                        ProcessingView()
                    case .result:
                        ResultView()
                    case .subscription:
                        SubscriptionView()
                    case .chat:
                        ChatView()
                    case .login:
                        LoginView()
                    }
                }
                .navigationBarItems(trailing: signOutButton())
        }
    }
    
    // 로그아웃 버튼을 별도 함수로 분리
    @ViewBuilder
    private func signOutButton() -> some View {
        Button(action: {
            authViewModel.signOut()
        }) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundColor(theme.colors.primary)
        }
    }
}
