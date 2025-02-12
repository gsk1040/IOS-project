import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("SwiftUI 실습!")
                .font(.largeTitle)
                .foregroundColor(.red)
                .background(Color.yellow)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
