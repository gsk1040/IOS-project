//
//  FunctionEx.swift
//  SwiftDay06Ex01
//
//  Created by 원대한 on 2/5/25.
//
struct FunctionEx {
    
    func run() {
        
        print("run FuctionEx")
        example01()
        
    }
    
    func example01(title:String) {
        print("첫번째 예제: \(title)")
        
        let value1:Int = 100
        let value2:Int = 150
        let total = add(x: value1, y:value2)
        print("\(value1) 더하기 \(value2)는 \(total)")
    }
    
    // add 함수 선언
    func add(x:Int, y:Int) -> Int {
        return x + y
    }
}
