//
//  Car.swift
//  SwiftDay07Lecture
//
//  Created by 원대한 on 2/6/25.
//

import Foundation

// 클래스 - 객체를 만들기 위한 틀
class Car {
    // 멤버 필드 선언
    // 캡슐화 (private)
    private var color: String
    private var speed: Int

    // 초기화 함수(생성자)
    init(color: String, speed: Int) {
        // 필드(self) = 매개변수
        self.color = color
        self.speed = speed
    }

    // 멤버 메서드 함수 - 객체 외부에서 접근
    func drive() {
        print("(color) 자동차가 (speed)km/h로 주행합니다.")
    }
}
