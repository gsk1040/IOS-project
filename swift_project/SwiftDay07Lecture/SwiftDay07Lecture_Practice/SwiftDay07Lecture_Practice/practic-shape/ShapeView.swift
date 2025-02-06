//
//  ShapeView.swift
/*import Foundation

class Shape {
    func draw() {
        print("도형을 그립니다.")
    }
}

// Shape 확장한 Circle과 Rectangle 클래스를 만들고 'data()' 메서드를 오버라이드하세요
// 'draw()' 메서드를 오버라이드하세요.

class ShapeView {
    // Array 선언
    //let shapeList = [Shape]() //방법1
    //let shapeList: [Shape] = [] //빈 쉐이프
    //let shape:ist = [Circle(), Rectangle(), Circle(), Circle()]
    //빈 배열에 데이터 추가: append() 사용. **예제를 10번 배워라**
    let shapeList: [Shape] = []
    
    init () {
        // init()함수의 목적은 초기화
        shapeList = [Circle(), Rectangle()]
    }
    
    func showlist() {
        for shape in shapeList {
            shape.draw()
        }
    }
    
    func appendShape(choice: int) {
        
    
    }
    func main() {
        
        // 5회 반복 Shape 생성
        // 생성 할 객ㄱ체 타입 선택 (1)Circle (2)Rectangle :1
        // 리스트에 Circle 객체 추가 완료!
        // 2반째 생성 할 객체 타입 선택 (1)Circle (2)Rectangle :2
        // 리스트에 Circle 객체 추가 완료!
        // 3번째 생성 할 객체 타입 선택 (1)Circle (2)Rectangle :
        
        var newShapeList: [Shape] = []
 
        for i in 1...5 {
            print("\(i)번째 생성 할 객체 타입 선택 (!)Circle (2)Rectangle", terminator: ": ")
            let choice: Int = Int(readLine() ?? "") ?? 0
            appendShape(choice: choice, newShapeList: newShapeList)
        }
        
        //showList()
        showlist()
        for shape in shapeList {
            shape.draw()
        }
        
        
        
    }
}
*/

import Foundation


class ShapeView {
    var shapes : [Shape]
    
    init(){
        shapes = [Circle(),Rectangle()]
    }
    
    func showlist(){
        for shape in shapes {
            shape.draw()
        }
    }
    
    func appendlist(choice : Int){
        
        if choice == 1{
            shapes.append(Circle())
        }else{
            shapes.append(Rectangle())
        }
        
        
    }
    
    
    func main(){
        for i in 1...5{
            print("\(i)번째 추가할 객체 타입 1:원 2:사각형",terminator: ": ")
            let choice = Int(readLine() ?? "0") ?? 0
            appendlist(choice: choice)
            
        }
        showlist()
    }
    
}
