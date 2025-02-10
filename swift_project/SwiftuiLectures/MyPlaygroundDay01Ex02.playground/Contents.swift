import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
        Text("Hello, SwiftUI!").lineLimit(1)
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}


PlaygroundPage.current.setLiveView(ContentView())
//PlaygroundPage.current.liveView = ContentView()
//문법이나 테스트용도로 사용됩니다.
