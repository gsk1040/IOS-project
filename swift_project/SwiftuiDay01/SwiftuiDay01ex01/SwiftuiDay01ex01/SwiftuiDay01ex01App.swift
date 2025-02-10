//
//  SwiftuiDay01ex01App.swift
//  SwiftuiDay01ex01
//
//  Created by 원대한 on 2/10/25.
//

import SwiftUI

@main
struct SwiftuiDay01ex01App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
