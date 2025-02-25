import SwiftUI

struct ContentView: View {

    let emojis = ["🚒", "🛻", "🚚", "🚐", "🚜", "🛴", "🛵", "🚲", "🏍", "🛺", "🚔", "🚍", "🚝", "🚠", "🚃", "🚂", "🚄", "🚅", "✈️", "🚀", "🚁", "🛸", "🚘", "🚖",]

    @State var emojiCount: Int = 6

    var body: some View {
        VStack {

            HStack {
                ForEach (emojis[0..<emojiCount], id: \.self) { emoji in
                    CardView(content: emoji)
                }

            }
            Spacer()
            HStack {
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .foregroundColor(.red)

    }

    var add: some View {
        Button {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")

        }
    }

    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }

}
