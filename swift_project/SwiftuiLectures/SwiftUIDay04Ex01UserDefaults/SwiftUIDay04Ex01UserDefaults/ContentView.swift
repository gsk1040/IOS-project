//
//  ContentView.swift
//  SwiftUIDay04Ex01UserDefaults
//
//  Created by 원대한 on 2/13/25.
//

import SwiftUI

struct ContentView: View {
    // 사용자 정보
    @State private var userName: String = ""
    //  TextField로 저장시 문자열로 저장됨
    @State private var userAge: String = ""
    // 앱 설정 정보
    @State private var isDarkMode: Bool = false
    
    
    // MARK: - body 함수
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("사용자 정보")) {
                    TextField("이름", text: $userName)
                    TextField("나이", text: $userAge)
                }
                Section(header: Text("다크 모드 설정")) {
                    Toggle("다크 모드 설정", isOn:  $isDarkMode)
                }
                Section(header: Text("버튼 그룹") ) {
                    Button("데이터 저장하기") {
                        saveData()
                    }
                    Button("데이터 불러오기") {
                        loadData()
                    }
                }
            }
        }
    } // end of body 바디도 함수기 때문에
    
    // MARK: - 저장기능
    func saveData() {
        UserDefaults.standard.set(userName, forKey: "userName")
        if let age = Int(userAge) {
            //텍스트 필드로 입력받은 데이터를 인트형 형변환후 저장
            UserDefaults.standard.set(age, forKey: "userAge")
        }
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        print("데이터저장완료!")
    }
    
    // MARK: - 불러오기 기능
    func loadData() {
        // State 상태변수에 데이터를 다시 불러 들이기
        userName = UserDefaults.standard.string(forKey: "") ?? "Unknoun"
        // userAge는 문자열 타입이다. 문자열로 형변환 필요.
        let age = UserDefaults.standard.integer(forKey: "userAge")
        userAge = "\(age)"
        isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        print("데이터불러오기완료!")
        // 데이터불러오기를 클릭하면 처음설정된것으로 불러와짐
    }
}// end of extension
    
#Preview {
    ContentView()
}
