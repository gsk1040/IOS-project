//
//  ContentView.swift
//  SwiftuiDay01ex03
//
//  Created by 원대한 on 2/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("기본 텍스트")
            Text("Hello, world!").foregroundStyle(.red)
            Text("큰 글자").foregroundStyle(.green)
            Text("피카츄").bold()
            Text("라이츄").italic()
            Text("밑줄표시").underline()
            Text("줄간격 \n설정").lineSpacing(10).padding()
            Text("다양한 스타일")
                .font(.title)
                .foregroundColor(.blue)
                .italic()
                .underline()
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
