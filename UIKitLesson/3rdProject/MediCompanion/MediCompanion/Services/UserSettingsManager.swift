//
//  UserSettingsManager.swift
//  MediCompanion
//
//  Created by 원대한 on 6/5/25.
//


// Services/UserSettingsManager.swift
import Foundation

class UserSettingsManager {
    static let shared = UserSettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let remainingScans = "remainingScans"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    var remainingScans: Int {
        get {
            return defaults.integer(forKey: Keys.remainingScans)
        }
        set {
            defaults.set(newValue, forKey: Keys.remainingScans)
        }
    }
    
    var hasCompletedOnboarding: Bool {
        get {
            return defaults.bool(forKey: Keys.hasCompletedOnboarding)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasCompletedOnboarding)
        }
    }
    
    // 사용자 설정 초기화
    func initializeIfNeeded() {
        if !defaults.bool(forKey: "hasInitialized") {
            // 최초 실행 시 무료 스캔 3회 제공
            remainingScans = 3
            defaults.set(true, forKey: "hasInitialized")
        }
    }
}