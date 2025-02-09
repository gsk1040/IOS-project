//
//  main.swift
//  SwiftProjectEx02회고시스템
//
//  Created by 원대한 on 2/9/25.
//

import Foundation


/*
 08. Weekly Project: 회고 시스템
 프로젝트 소개
 Swift 언어를 활용한 CLI 기반 회고 시스템(Reflection System)을 개발합니다. 사용자가 하루의 회고를 기록하고, 수정 및 삭제하며, 특정 날짜의 회고를 검색할 수 있는 기능을 제공합니다.
 이 프로젝트는 CRUD 기능과 Swift 기본 문법(제어문, 클래스, 구조체, 셋, 리스트, 딕셔너리 등)을 포함하여 Swift 학습자들이 실습을 통해 기초 문법을 익히고 실제 프로젝트 개발 경험을 쌓도록 돕습니다.
 프로젝트 시나리오
 Swift로 개발하는 CLI 기반 회고 시스템은 사용자가 하루의 회고를 기록하고, 저장된 회고 데이터를 쉽게 관리할 수 있는 기능을 제공합니다. 회고 시스템은 단순한 CRUD 기능을 통해 회고 추가, 조회, 수정, 삭제, 그리고 전체 회고 목록 출력 기능을 지원합니다.
 회고 데이터는 날짜(Date)를 키(key)로 사용하여, 내용(Content)을 값(value)으로 저장하는 딕셔너리(Dictionary) 형태로 관리됩니다. 사용자는 원하는 날짜에 작성한 회고를 조회하거나 수정, 삭제할 수 있으며, 전체 회고 목록을 출력하여 저장된 회고를 한눈에 확인할 수 있습니다.
 기능 목록 및 설명 (CRUD)
 기능
 설명
 입력 예시
 출력 예시
 1. 회고 추가
 특정 날짜에 대한 회고 내용을 추가합니다.
 날짜: 2024-12-25
 내용: 오늘은 Swift를 공부했다.
 회고가 추가되었습니다.
 2. 회고 조회
 특정 날짜의 회고 내용을 검색하여 출력합니다.
 날짜: 2024-12-25
 날짜: 2024-12-25 내용: 오늘은 Swift를 공부했다.
 3. 회고 수정
 기존에 저장된 회고 내용을 새로운 내용으로 수정합니다.
 날짜: 2024-12-25
 새로운 내용: Swift 프로젝트를 완료했다.
 회고가 수정되었습니다.
 4. 회고 삭제
 특정 날짜의 회고 데이터를 삭제합니다.
 날짜: 2024-12-25
 회고가 삭제되었습니다.
 5. 전체 회고 목록
 저장된 모든 회고 내용을 날짜별로 출력합니다.
 -
 날짜별 회고 목록 출력
 6. 프로그램 종료
 프로그램을 종료합니다.
 -
 프로그램을 종료합니다.
 기능별 상세 흐름
 1. 회고 추가 (Add)
 사용자가 입력한 날짜와 회고 내용을 딕셔너리에 저장합니다.
 같은 날짜에 이미 회고가 존재하면, 새로운 회고로 덮어쓰지 않고 경고 메시지를 출력할 수 있습니다.
 입력값: 날짜(String), 내용(String)
 출력값: "회고가 추가되었습니다."
 2. 회고 조회 (Read)
 사용자가 특정 날짜를 입력하면, 해당 날짜에 작성된 회고 내용을 출력합니다.
 입력한 날짜에 회고가 없으면 "해당 날짜의 회고가 없습니다."라는 메시지를 출력합니다.
 입력값: 날짜(String)
 출력값: 날짜와 회고 내용
 3. 회고 수정 (Update)
 사용자가 특정 날짜를 입력하고, 새로운 회고 내용을 입력하면 기존 내용을 수정합니다.
 입력한 날짜에 회고가 없으면 "해당 날짜의 회고가 없습니다."라는 메시지를 출력합니다.
 입력값: 날짜(String), 새로운 내용(String)
 출력값: "회고가 수정되었습니다."
 4. 회고 삭제 (Delete)
 사용자가 특정 날짜를 입력하면, 해당 날짜의 회고 데이터를 삭제합니다.
 입력한 날짜에 회고가 없으면 "해당 날짜의 회고가 없습니다."라는 메시지를 출력합니다.
 입력값: 날짜(String)
 출력값: "회고가 삭제되었습니다."
 5. 전체 회고 목록 출력 (List All)
 저장된 모든 회고 내용을 날짜별로 출력합니다.
 회고 데이터가 없으면 "저장된 회고가 없습니다."라는 메시지를 출력합니다.
 입력값: 없음
 출력값: 날짜별 회고 목록
 입출력 예시
 === 회고 시스템 ===
 1. 회고 추가
 2. 회고 조회
 3. 회고 수정
 4. 회고 삭제
 5. 전체 회고 목록 출력
 6. 종료

 메뉴를 선택하세요: 1
 날짜를 입력하세요 (예: 2024-12-25): 2024-12-25
 회고 내용을 입력하세요: 오늘은 Swift를 공부했다!
 회고가 추가되었습니다.

 메뉴를 선택하세요: 2
 조회할 날짜를 입력하세요: 2024-12-25
 날짜: 2024-12-25
 내용: 오늘은 Swift를 공부했다!

 메뉴를 선택하세요: 3
 수정할 날짜를 입력하세요: 2024-12-25
 새로운 회고 내용을 입력하세요: Swift 프로젝트를 완료했다!
 회고가 수정되었습니다.

 메뉴를 선택하세요: 4
 삭제할 날짜를 입력하세요: 2024-12-25
 회고가 삭제되었습니다.

 메뉴를 선택하세요: 5
 === 저장된 회고 목록 ===
 날짜: 2024-12-24
 내용: 알고리즘 문제를 풀었다.

 날짜: 2024-12-26
 내용: Swift 프로젝트를 시작했다.

 메뉴를 선택하세요: 6
 프로그램을 종료합니다.

 */
// #의사코드
// 1.사용자 요구사항:하루의 회고를 기록하고, 수정 및 삭제하며, 특정 날짜의 회고를 검색할 수 있는 기능
//  ㄱ.회고(검색) ㄴ.수정 ㄷ.삭제 ㄹ.특정날짜데이터 배열? 또는 함수? 구조체?
// 2. 사용가능한 문법제약사항:CRUD 기능과 Swift 기본 문법(제어문, 클래스, 구조체, 셋, 리스트, 딕셔너리 등)
// 3.회고 데이터는 날짜(Date)를 키(key)로 사용하여, 내용(Content)을 값(value)으로 저장하는 딕셔너리(Dictionary) 형태로 관리됩니다.사용자는 원하는 날짜에 작성한 회고를 조회하거나 수정, 삭제할 수 있으며, 전체 회고 목록을 출력하여 저장된 회고를 한눈에 확인할 수 있습니다.
// 4.필요한 구조체를 제작한다.
//

// 회고를 저장할 딕셔너리를 만든다
// [String: String]은 [날짜: 회고내용] 형태로 저장
var myReflections: [String: String] = [:]

// 메뉴를 보여주는 함수
func showMenu() {
    print("===== 나의 회고 일기장 =====")
    print("1번: 회고 쓰기")
    print("2번: 회고 읽기")
    print("3번: 회고 수정하기")
    print("4번: 회고 삭제하기")
    print("5번: 전체 회고 보기")
    print("6번: 끝내기")
    print("원하는 번호를 입력해주세요: ", terminator: "")
}

// 1번: 회고 쓰기
func writeReflection() {
    print("날짜를 입력해주세요 (예: 2024-02-09): ", terminator: "")
    let date = readLine() ?? ""  // 날짜 입력받기
    
    // 이미 해당 날짜의 회고가 있는지 확인
    if myReflections[date] != nil {
        print("이미 이 날짜에 회고가 있어요!")
        return
    }
    
    print("오늘의 회고를 입력해주세요: ", terminator: "")
    let content = readLine() ?? ""  // 회고 내용 입력받기
    
    // 딕셔너리에 새 회고를 저장
    myReflections[date] = content
    print("회고가 저장되었어요! 👍")
}

// 2번: 회고 읽기
func readReflection() {
    print("읽고 싶은 날짜를 입력해주세요 (예: 2024-02-09): ", terminator: "")
    let date = readLine() ?? ""
    
    // 해당 날짜의 회고가 있는지 확인
    if let content = myReflections[date] {
        print("===== \(date)의 회고 =====")
        print(content)
        print("=======================")
    } else {
        print("그 날짜의 회고가 없어요 😢")
    }
}

// 3번: 회고 수정하기
func updateReflection() {
    print("수정하고 싶은 날짜를 입력해주세요 (예: 2024-02-09): ", terminator: "")
    let date = readLine() ?? ""
    
    // 해당 날짜의 회고가 있는지 확인
    if myReflections[date] != nil {
        print("새로운 회고 내용을 입력해주세요: ", terminator: "")
        let newContent = readLine() ?? ""
        myReflections[date] = newContent
        print("회고가 수정되었어요! ✍️")
    } else {
        print("그 날짜의 회고가 없어요 😢")
    }
}

// 4번: 회고 삭제하기
func deleteReflection() {
    print("삭제하고 싶은 날짜를 입력해주세요 (예: 2024-02-09): ", terminator: "")
    let date = readLine() ?? ""
    
    // 해당 날짜의 회고가 있는지 확인
    if myReflections[date] != nil {
        myReflections.removeValue(forKey: date)  // 회고를 삭제
        print("회고가 삭제되었어요! 🗑️")
    } else {
        print("그 날짜의 회고가 없어요 😢")
    }
}

// 5번: 전체 회고 보기
func showAllReflections() {
    if myReflections.isEmpty {  // 저장된 회고가 하나도 없다면
        print("아직 작성된 회고가 없어요 📝")
        return
    }
    
    print("===== 전체 회고 목록 =====")
    // 날짜순으로 정렬
    for (date, content) in myReflections.sorted(by: { $0.key < $1.key }) {
        print("📅 날짜: \(date)")
        print("📝 내용: \(content)")
        print("----------------------")
    }
}

// 메인 프로그램 시작
print("환영합니다! 회고 일기장을 시작할게요! 😊")

var isRunning = true  // 프로그램을 계속 실행할지 결정하는 변수

while isRunning {  // 프로그램이 실행중이면 계속 반복
    showMenu()  // 메뉴 보여주기
    
    // 사용자가 선택한 메뉴 번호를 입력받기
    if let choice = readLine() {
        switch choice {
        case "1":
            writeReflection()    // 회고 쓰기
        case "2":
            readReflection()     // 회고 읽기
        case "3":
            updateReflection()   // 회고 수정하기
        case "4":
            deleteReflection()   // 회고 삭제하기
        case "5":
            showAllReflections() // 전체 회고 보기
        case "6":
            print("회고 일기장을 종료할게요! 안녕히 가세요! 👋")
            isRunning = false    // 프로그램 종료
        default:
            print("1부터 6까지의 숫자 중에서 선택해주세요! 🔢")
        }
    }
    
    if isRunning {  // 프로그램이 계속 실행중이라면
        print("\n계속하려면 엔터를 눌러주세요...")
        _ = readLine()  // 사용자가 엔터를 누르기를 기다려라
    }
}
