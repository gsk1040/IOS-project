//
//  FunctionEx02.swift
//  SwiftDay06Ex01
struct FunctionEx02 {
    
    static func run() {
        print("FunctionEx02.run()")
        
        // 다중 반환 값 예제
        let userInfo = getUserInfo()
        print("\(userInfo.name)님은 \(userInfo.age)세입니다")
    }
    /*
     // 이름과 나이를 입력받는 함수
     func getUserInfo() -> (name: String, age: Int){
     print("성명", terminator: ": ")
     let name = readLine()
     print("나이", terminator: ": ")
     let age = Int(readLine() ?? "") ?? 0
     
     return (name!, age)
     }
     }
     */ 강사님이 쓰신 예제
    
