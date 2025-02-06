## **1. 객체지향 프로그래밍(OOP)란?**

객체지향 프로그래밍(Object-Oriented Programming, OOP)은 **객체(Object)** 라는 개념을 중심으로 프로그램을 설계하고 구현하는 방식입니다.

즉, 현실 세계의 개념을 프로그래밍에 반영하여 **코드의 재사용성과 유지보수성을 향상**시키는 방법입니다.

<details>
<summary>객체(Object)와 클래스(Class) 개념?</summary>
<div markdown="1">

### **📌 객체 (Object)**

- **현실 세계의 사물이나 개념을 코드로 표현한 것**
- 객체는 속성(데이터)과 동작(메서드)을 가집니다.
- 예를 들어, "자동차"라는 객체는 `색상`, `모델`, `속도` 등의 **속성**과 `달리다()`, `정지하다()` 등의 **동작**을 가집니다.

### **📌 클래스 (Class)**

- **객체를 생성하기 위한 설계도(틀)**
- 객체의 속성과 동작을 정의하는 역할을 합니다.
- 클래스는 여러 개의 객체를 생성하는 데 사용할 수 있습니다.

</div>
</details>

# 📚 객체지향 프로그래밍(OOP)의 4가지 핵심 특징

<details>
<summary><h2>1. 🔒 캡슐화 (Encapsulation)</h2></summary>

- **정의**: 데이터와 메서드를 하나의 객체로 묶고 외부 접근을 제한
- **목적**: 데이터 보호 및 무결성 유지
- **구현 방법**:
  - private/protected 접근 제어자 사용
  - getter/setter 메서드 활용
  </details>

<details>
<summary><h2>2. 🔄 상속 (Inheritance)</h2></summary>

- **정의**: 부모 클래스의 특성을 자식 클래스가 물려받음
- **장점**:
  - 코드 재사용성 향상
  - 유지보수 용이성
- **구현 예시**:
  ```swift
  class Parent { }
  class Child: Parent { }
  ```
  </details>

<details>
<summary><h2>3. 🎭 다형성 (Polymorphism)</h2></summary>

- **정의**: 같은 메서드를 다양한 방식으로 구현
- **종류**:
  - 오버라이딩 (Overriding)
  - 오버로딩 (Overloading)
- **핵심**: `override` 키워드로 메서드 재정의
</details>

<details>
<summary><h2>4. 🎯 추상화 (Abstraction)</h2></summary>

- **정의**: 핵심 정보만 남기고 불필요한 정보 숨김
- **구현 방법**:
  - 추상 클래스
  - 프로토콜/인터페이스
- **장점**: 복잡성 감소, 재사용성 증가
</details>

---

<details>
<summary><h2>💻 실습 예제: 도형 그리기 프로그램</h2></summary>

```swift
// 1. Shape 부모 클래스 정의
class Shape {
    func draw() {
        print("도형을 그립니다")
    }
}

// 2. 자식 클래스 구현
class Circle: Shape {
    override func draw() {
        print("○ 원을 그립니다")
    }
}

class Rectangle: Shape {
    override func draw() {
        print("□ 사각형을 그립니다")
    }
}

// 3. 실행 코드
let shapes: [Shape] = [Circle(), Rectangle()]
for shape in shapes {
    shape.draw()
}
```

**실행 결과**:

```
○ 원을 그립니다
□ 사각형을 그립니다
```

</details>

# 🤓 진짜 왕초보의 구조체/클래스 공부 일기

<details>
<summary><h2>📘 책 예제로 배워보는 구조체</h2></summary>

```swift
struct Book {
    var title: String
    var author: String

    func displayInfo() {
        print("\(title) by \(author)")
    }
}
```

**😅 내 생각들:**

- 음... `struct`가 클래스랑 다르다는데 아직 잘 모르겠다
- `var title: String` 이런거는 변수 만드는거 같은데 왜 여기다 만들지?
- `displayInfo()` 이건 함수 같은데... 이름 잘 지었나?
</details>

<details>
<summary><h2>🤔 구조체로 책 만들어보기</h2></summary>

```swift
let book1 = Book(title: "Swift Programming", author: "John Doe")
book1.displayInfo()

var book2 = book1
book2.title = "Advanced Swift"
```

**🙈 이해 안 되는 부분:**

- 왜 `Book(title:` 이렇게 쓰는거지? 그냥 `Book("Swift Programming")`은 안되나?
- `let`이랑 `var` 차이가 뭐였더라... 계속 헷갈려
- 복사된다고 하는데 이게 좋은건가...?
</details>

<details>
<summary><h2>🚗 실습: 자동차로 비교해보기</h2></summary>

```swift
class Car {
    var brand: String
    var model: String

    init(brand: String, model: String) {
        self.brand = brand
        self.model = model
    }
}
```

**😱 헷갈리는 것들:**

- 클래스는 왜 `init` 을 꼭 써야하지?
- `self`는 뭐지...? 왜 쓰는거지?
- 구조체는 이거 안써도 되던데 왜지?
</details>

<details>
<summary><h2>✨ 내가 정리해본 차이점</h2></summary>

**구조체는:**

- 복사가 된다 (아직도 이해 못함...)
- `init` 안써도 된다 (편함!)
- 상속이 안된다 (이건 나중에 공부해야지...)

**클래스는:**

- 복사가 안되고 참조된다 (이것도 이해 못함 😭)
- `init` 꼭 써야함 (귀찮...)
- 상속된다 (이것도 나중에...)

**🌟 오늘의 깨달음:**
사실 아직도 많이 헷갈리는데... 일단 작은 데이터는 구조체 쓰라고 하니까 그렇게 해야겠다!

</details>

<details>
<summary><h2>💡 앞으로 더 공부할 것</h2></summary>

1. `init`이랑 `self` 개념 제대로 이해하기
2. 값 타입vs참조 타입 차이 알아보기
3. 상속이 뭔지 공부하기
4. 메모리 어떻게 동작하는지 찾아보기

**🙏 선배님들 도와주세요:**

- 실제로는 이거 어떻게 쓰는지 예제 좀 더 보고 싶어요
- 진짜 현업에서는 뭘 더 많이 쓰나요?
- 이거 외우고 있어야 하나요...? 😅
</details>
