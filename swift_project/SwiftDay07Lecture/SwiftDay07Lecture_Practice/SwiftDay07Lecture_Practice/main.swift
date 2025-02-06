//
//  main.swift
//  SwiftDay07Lecture_Practice
//
//  Created by 원대한 on 2/6/25.
//

import Foundation

//## **✅ 종합 실습 문제**

//### **📌 문제: 객체지향 개념을 활용하여 "도형 그리기 프로그램"을 구현하시오.**

//1. `Shape`라는 부모 클래스를 만듭니다.
//2. `draw()` 메서드를 선언하고, `Circle`, `Rectangle` 클래스를 만들어 `draw()`를 각각 다르게 구현.
//3. `Shape` 객체 배열(Array)을 만들고 Circle, Rectangle 객를 배열에 저장하고 반복 출력하도록 구현.
/* class Shape {
    func draw() {
         print("도형을 그리세요")
     }
}

 class Circle: Shape {
    override func draw() {
        print("원을 그립니다.")
    }
}
 class Rectangle: Shape {
    override func draw() {
        print("사각형을 그립니다.")
    }
}

let shapes: [Shape] = [Circle(), Rectangle(), Circle(), Rectangle()]

for shape in shapes {
    shape.draw()
}
*/

let view = ShapeView()
view.main()
