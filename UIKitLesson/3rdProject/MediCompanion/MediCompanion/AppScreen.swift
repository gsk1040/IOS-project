//
//  AppScreen.swift
//  MediCompanion
//
//  Created by 원대한 on 6/5/25.
//


// AppState.swift (업데이트)
import SwiftUI

enum AppScreen: Hashable {
    case home
    case camera
    case processing
    case result
    case subscription
    case chat
    case login
}

class AppState: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var remainingScans: Int = UserSettingsManager.shared.remainingScans
    @Published var healthData: [HealthItem]?
    @Published var capturedImage: UIImage?  // 추가된 capturedImage 속성
    // 사용자 관련 속성은 AuthViewModel로 이동
    
    func navigateTo(_ screen: AppScreen) {
        navigationPath.append(screen)
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
    
    // 건강 데이터 저장
    func saveHealthData(_ data: [HealthItem]) {
        self.healthData = data
    }
    
    // 스캔 사용
    func useFreeScan() {
        remainingScans -= 1
        UserSettingsManager.shared.remainingScans = remainingScans
    }
}


