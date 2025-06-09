//
//  MediCompanionApp.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

// MediScanApp.swift
import SwiftUI
import Firebase

@main
struct MediCompanionApp: App {
    // UIApplicationDelegateAdaptor 추가
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    @StateObject private var authViewModel = AuthViewModel()
    

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(authViewModel)
        }
    }
}
