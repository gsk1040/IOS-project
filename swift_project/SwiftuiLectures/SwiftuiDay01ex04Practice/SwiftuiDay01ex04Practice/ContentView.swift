//
//  ContentView.swift
//  SwiftuiDay01ex04Practice
//
//  Created by 원대한 on 2/10/25.
//

//시나리오 전략 배열 크기 확인하기
// 단어추가시 중복된 단어가 들어가지 않도록 수정하라는 사용자요구에서는 일단...배열이 존재한다는 가정하에 설계가 들어가게 된다.
// 단어를 입력 받을 경우 사용자의 입력에서 값이 배열안에 동일한 값이 나올경우 조건문을 활용하여 수정한다. 이미 있는 단어라면 "이미 존재하는 단어입니다"라는 프린트 없는 경우 (리드라인()) 단어가 추가되었습니다.
//따라서...미리 단어가 몇단어 들어가있는 상태로 사용자가 확인가능하도록 설계해야한다.
//배열크기확인기능... 배열갯수를 계산하고 화면에 표시
// 사용자입력:리드라인 배열확인후 조건문으로 있으면 해당단어 인덱스를 메시지로 표시하고 없으면 아이쿠...입력하신 단어는 찾아보니..없네요. 다른 단어를 입력해보시겠어요??
//Swift 애니메이션... 단어가 추가되면 여러 특수효과 애니메이션 적용하기

import SwiftUI

struct ContentView: View {
    @State private var words: [String] = ["피카츄","라이츄","파이리"]
    @State private var newWord: String = ""  // 새로 입력할 단어
    @State private var wordToDelete:String = "" // 삭제할 단어
    @State private var message: String = "단어를 추가 하세요"  // 상태 메시지
    func addWord(){
        words.append(newWord) //배열에 새단어 추가
        newWord = "". //입력 필드 비우기
        message = "단어가 추가되었습니다" //메시지를 입력하세요
    }
    func DeleteWord() {
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
        }
    }
    
    #Preview {
        ContentView()
    }

