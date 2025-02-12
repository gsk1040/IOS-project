//
//  ContentView.swift
//  SwiftuiDay03Ex01
//
//  Created by 원대한 on 2/12/25.
//

import SwiftUI

class CntClass {
    var count: Int
    
    init(_ count: Int = 0){
        self.count = count
    }
}

struct HomeView: View {
    // 화면을 갱신하는것. 상태변수 재렌더링됨//스트럭트 불변과 상관없고...뷰내부에 만들어져서 작동한다.그게 스테이트
   //@State var count = 0
    var countRef: CntClass = CntClass(0)
    
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 200, height: 300)
            
            Text("Welcome to SwiftUI!")
                .padding(20)
            Button("증가") {
                print("증가 버튼 눌렀다")
                countRef.count += 1
            }
        }
    }
}

struct settings: View {
    var body: some View {
        VStack {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 200, height: 200)
            Text("System Setting Page")
        }
    }
}
struct profile: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 200, height: 200)
            Text("Profile Page")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
                }
            settings().tabItem {
                Label("Settings", systemImage: "gear")
            }
            profile().tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
