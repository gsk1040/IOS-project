//
//  main.swift
//  SwiftDay07Lecture
//
//  Created by 원대한 on 2/6/25.
//


import Foundation

class Car {
    // 멤버 필드 선언
    // 캡슐화
    var color: String
    var speed: Int
    
    //초기화함수 생성자
    init(color:String, speed:Int) {
        // 필드 매개변수
        self.color = color
        self.speed = speed
    }
    
    // 멤버 메서드 함수 - 객체 외부에서 접근
}
