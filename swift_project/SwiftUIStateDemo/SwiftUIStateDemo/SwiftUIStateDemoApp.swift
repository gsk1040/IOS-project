//
//  SwiftUIStateDemoApp.swift
//  SwiftUIStateDemo
//
//  Created by 원대한 on 3/28/25.
//

import SwiftUI

@main
struct SwiftUIStateDemoApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView()
                .environmentObject(UserViewModel())
        }
    }
}
