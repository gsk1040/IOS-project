//
//  main.swift
//  SwiftDay02Ex01
//
//  Created by 원대한 on 1/23/25.
// 이것은 한글주석
/*
 이것은 여러줄 주석입니다
 이것이 바로그것입니다
 */
    
import Foundation

//let 안녕 = "안녕하셍";
//var hello = "Hello, World"
//print(안녕)// 줄바꿈 자동 들어감

// 변수는 값을 변경할 수 있다.
//hello = "안녕 세상"

//print(hello, terminator: "")
// 특수 문자 \ㅜ \t \r \a ...
//터미네이터 속성의 기본값(default)은 terminator: "\n"


// 이전 예제를 주석처리하고 다음 예제 실습
// readLine()으로 데이터 입력

// 성명과 나이를 입력 빋이사 출력하는 예제
// 나이의 5년 후 나이를 출력하라.
// 성명은 상수로 선언
// 나이는 변수로 선언

// 변수나 상수는 맨위에 선언하는게 일반적
// 성명과 나이를 입력 받을 변수 선언
//var name: String = ""
//var age: Int = 0

//print( "성명 입력: ", terminator: "")
//name = readLine() ?? ""
//print("나이 입력: ", terminator: "")
//age = Int(readLine() ?? "0") ?? 0

// 변수는 값을 바꿔 줄수 있다.
//age = age + 5

//print("\(name)님의 나이는 \(age)입니다.")





// 옵셔널의 값 확인 (언랩핑)

//var name: String? = nil

// name = "홍길동"

//let userName = name ?? "noname"
//print("성명은 " + userName + "입니다.")


//if let userName = name {
//    print("성명은 " + userName + "입니다")
//} else {
/*
print("첫 번째 숫자를 입력하세요:")
let input1 = readLine()
print("두 번째 숫자를 입력하세요:")
let input2 = readLine()
print("세 번째 숫자를 입력하세요:")
let input3 = readLine()

if let num1 = Int(input1 ?? ""), let num2 = Int(input2 ?? ""), let num3 = Int(input3 ?? "") {
    var largest = num1
    var middle = num1
    var smallest = num1
    
    if num2 > largest {
        largest = num2
    }
    if num3 > largest {
        largest = num3
    }
    
    if (num1 < num2 && num1 > num3) || (num1 > num2 && num1 < num3) {
        middle = num1
    } else if (num2 < num1 && num2 > num3) || (num2 > num1 && num2 < num3) {
        middle = num2
    } else {
        middle = num3
    }
    
    smallest = num1 + num2 + num3 - largest - middle
    
    print("큰 수:\(largest)")
    print("중간 수:\(middle)")
    print("작은 수:\(smallest)")
} else {
    print("숫자를 정확히 입력하세요.")
}
*/
//if 조건문 사용 방법
/*
 식별자를 선언할때 모든 문자 사용 가능. 단, 특수문자, 공백, 숫자로 시작하지 말기 의사코드 (정해진 규칙은 없다. 논리적으로 내 나름대로 작성)
 1. 나이를 입력 받는다.
    1.1. 나이를 저장 할 변수 입력
    1.2."나이 입력" 지문
    1.3.나이를 입력 받는다.
 2. 나이가 18보다 크면 성인이라고 출력.
 3. 나이가 18이거나 작으면 미성년이라고 출력.
 */
// 의사코드
/*
1. 각각 다른 정수 3개 입력
1.1 변수 선언: 큰수, 중간, 작은수
1.2 정수 3개 순서대로 입력
2. 각각 비교해서 제일큰수, 중간수, 작은수를 판별한다•
    2.1 결과 변수 선언: 큰수(max), 중간(mid), 작은수(min)
    2.2 입력 받은 수중 2개를 비교해서 큰것은 max에 저장
    2.3 작은 것은 min에 저장
    2.4 입력 받은 나머지 수를 max나 min과 비교
        2.4.1 max보다 크다면 기존 max는 min이 되고 나머지 숫자가 max
        2.4.2 max보다 작다면 min과 비교하고 min보다 작다면 나머지가 min이 된다. 기존 min은 middle
        2.4.3 max보다 크지 않고 min보다 작지 않다면 나머지 숫자가 mid
 3. max, mid, min을 순서대로 출력한다.
 */
//입력 받을 변수 선언 또는 let으로 선언해서 상수로 받을 수 있다.
//var num1:Int?, num2:Int?, num3:Int?

//입력 (언랩핑)
//print("각각 다른 정수 3개 입력: ", terminator: "")
//num1 = Int(readLine() ?? "0")
//num2 = Int(readLine() ?? "0")
//num3 = Int(readLine() ?? "0")

//print("입력 받은 정수는 \(num1!), \(num2!), \(num3!) 입니다.")

//if num1! > num2!
    
    
    
    
//의사코드
//1.학점기준을 먼저 설정한다
 //   1.1 90점 이상은 A
//    1.2 80점 이상은 B
//    1.3 70점 이상은 C
//    1.4 60점 이상은 D
//    1.5 60점 미만은 F
//2. 학생의 학점을 입력 받는다

//3.  학생의 학점과 1에서 설정한 학점 기준에 따라 등급을 매긴다
 
 /*let grade = 70
 
 switch grade {
 case 90...100:
 print("A학점")
 case 80..<90:
 print("B학점")
 case 70..<80:
 print("C학점")
 case 60..<70:
 print("D학점")
 default:
 print("F학점")
 }
 */

/*let size = 10
var total:Int = 0
for num in 1...size {
    print("\(num)", terminator:num < 10 ? " + ": " = ")
    total += num
}

print(total)
*/
// 전기수학: 옴의 법칙
// V = I * R (전압 = 전류 * 저항)

// 상수 선언 (저항 값)
/*print("점수를 입력하세요:")
if let input = readLine(), let score = Int(input) {
    switch score {
    case 90...100:
        print("학점: A")
    case 80..<90:
        print("학점: B")
    case 70..<80:
        print("학점: C")
    case 60..<70:
        print("학점: D")
    default:
        print("학점: F")
    }
} else {
    print("유효한 숫자를 입력하세요.")
}

// 문제: 입력받은 숫자의 구구단을 출력하는 프로그램을 작성하세요.
// 입력: 3
// 예상 출력:
// 3 x 1 = 3
// 3 x 2 = 6
// ...
// 3 x 9 = 27

 let number = 2
for i in 1...9 {
    print("(number) x (i) = (number * i)")

