//
//  ContentView.swift
//  SwiftuiDay03Ex02
//
//  Created by 원대한 on 2/12/25.
//

import SwiftUI

struct ContentView: View {
    
    func createContentView(_ showTitle: Bool) -> some View {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Text("Hello, World!")
    }
    
    var body: some View {
        createContentView(true)
        
        
    }
}

#Preview {
    ContentView()
}
