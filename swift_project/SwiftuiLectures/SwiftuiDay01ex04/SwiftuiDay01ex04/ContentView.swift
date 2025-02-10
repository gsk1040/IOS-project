import SwiftUI

struct ContentView: View {
    @State private var words: [String] = ["사과","딸기","바나나"]   // 단어를 저장할 배열
    @State private var newWord: String = ""  // 새로 입력할 단어
    @State private var wordToDelete: String = "" // 삭제할 단어
    @State private var message: String = "단어를 추가 하세요"  // 상태 메시지
    
    func addWord() {
        print("추가 버튼 누름", newWord)
        // words는 State이므로 상태 값이 변경 되면 자동 재 랜더링.
        words.append(newWord)
        newWord = ""
        message = "새 단어가 추가되었습니다."
    }
    
    func removeWord() {
        print("삭제 버튼 누름", wordToDelete)
        // 입력 된 단어와 일치하는 단어를 words에서 찾기: firstIndex(of: )
        // 목록에서 해당 단어 삭제: remove()
        if let index = words.firstIndex(of: wordToDelete) {
            words.remove(at: index)
            wordToDelete = ""
            message = "단어 목록에서 \(wordToDelete)를 삭제 했습니다."
        } else {
            message = "단어 목록에 \(wordToDelete)는 없습니다."
        }
    }
    
    var body: some View {
            
            VStack {
                Text ("단어 관리 프로그램")
                    .font(.largeTitle)
                    .padding()
                HStack {
                    TextField("단어 입력", text: $newWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("추가") {
                        addWord()
                    }
                }
                .padding()
                
                List (words, id: \.self) { word in
                    Text(word)
                }
                .padding()
                
                HStack {
                    TextField("단어 삭제", text: $wordToDelete)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("삭제") {
                        removeWord()
                    }
                }
                .padding()
                
                Text(message)
                    .foregroundStyle(.red)
                    .padding()
            } // end VStack
            .padding()
        }
    }

    struct ArrayManagerView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
