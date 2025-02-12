//
//  ContentView.swift
//  SwiftuiDay03Ex01Practice
//
//  Created by 원대한 on 2/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Opaque Type in SwiftUI")
                .font(.title)
                .padding()
            Divider()
            getCustomText()
        }
    }

    func getCustomText() -> some View {
        Text("This is a custom text view.")
            .foregroundColor(.blue)
    }
}

