// 메인 실행 파일

print("\n=== 누가복음 19장 구현 ===\n")

// 1. 삭개오 이야기
print("1. 삭개오 이야기")
print("----------------")
let zacchaeus = TaxCollector(name: "삭개오", city: "여리고", wealth: 10000)
zacchaeus.describe()
zacchaeus.meetJesus()
zacchaeus.repent()
zacchaeus.describe()

// 2. 므나 비유
print("\n2. 므나 비유")
print("----------------")
var servants = [
    Mina(servantName: "첫째 종", amount: 1),
    Mina(servantName: "둘째 종", amount: 1),
    Mina(servantName: "셋째 종", amount: 1)
]

for i in 0..<servants.count {
    let result = servants[i].invest()
    print("\(servants[i].servantName)이 \(result) 므나를 만들었습니다.")
}

// 3. 성전 정화
print("\n3. 성전 정화")
print("----------------")
let activities: [TempleActivity] = [.selling, .buying, .teaching, .praying]

for activity in activities {
    print("활동: \(activity.description())")
    print("허용 여부: \(activity.isPermitted() ? "허용됨" : "허용되지 않음")")
}


// 클래스 정의
class Person {
    var name: String

    init(name: String) {
        self.name = name
    }
}

// 구조체 정의
struct Animal {
    var type: String
}

// 클래스 인스턴스 생성
let person1 = Person(name: "Alice")
let person2 = person1
person2.name = "Bob"

print(person1.name)  // 출력: Bob (참조 타입)

// 구조체 인스턴스 생성
var animal1 = Animal(type: "Cat")
var animal2 = animal1
animal2.type = "Dog"

print(animal1.type)  // 출력: Cat (값 타입)
