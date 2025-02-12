//
//  EnvironmentObjectEx.swift
//  SwiftuiDay03Ex03
//
//  Created by 원대한 on 2/12/25.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var username: String = "Guest"
}

struct ParentView: View {
    @StateObject var settings = UserSettings()

    var body: some View {
        ChildView().environmentObject(settings)
    }
}

struct ChildView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        Text("Hello, \(settings.username)!")
    }
}

struct EnvironmentObjectEx: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    EnvironmentObjectEx()
}
