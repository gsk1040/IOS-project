//
//  ZacchaeusStory.swift
//  miniPractice
//
//  Created by 원대한 on 2/7/25.
//
// 사람 기본 클래스
class Person {
    private var name: String
    private var city: String
    
    init(name: String, city: String) {
        self.name = name
        self.city = city
    }
    
    func getName() -> String {
        return name
    }
    
    func describe() {
        print("\(name)은(는) \(city)에 살고 있습니다.")
    }
}

// 세리장 클래스
class TaxCollector: Person {
    private var wealth: Int
    private var hasMetJesus: Bool = false
    
    init(name: String, city: String, wealth: Int) {
        self.wealth = wealth
        super.init(name: name, city: city)
    }
    
    func meetJesus() {
        hasMetJesus = true
        print("\(getName())가 예수님을 만났습니다.")
    }
    
    func repent() {
        if hasMetJesus {
            let donation = wealth / 2
            wealth -= donation
            print("\(getName()): 재산의 절반인 \(donation)을 가난한 자들에게 나누어 주겠습니다.")
            print("\(getName()): 누구의 것을 토색한 일이 있으면 네 배로 갚겠습니다.")
        }
    }
    
    override func describe() {
        super.describe()
        print("재산은 \(wealth)이며, 예수님을 \(hasMetJesus ? "만났습니다." : "아직 만나지 못했습니다.")")
    }
}

// 므나 구조체
struct Mina {
    let servantName: String
    var amount: Int
    
    mutating func invest() -> Int {
        switch servantName {
        case "첫째 종":
            amount *= 10
        case "둘째 종":
            amount *= 5
        case "셋째 종":
            // 수건에 싸둔 한 므나
            break
        default:
            break
        }
        return amount
    }
}

// 성전 정화 관련 열거형
enum TempleActivity {
    case selling
    case buying
    case teaching
    case praying
    
    func isPermitted() -> Bool {
        switch self {
        case .selling, .buying:
            return false
        case .teaching, .praying:
            return true
        }
    }
    
    func description() -> String {
        switch self {
        case .selling:
            return "물건을 팔고 있습니다."
        case .buying:
            return "물건을 사고 있습니다."
        case .teaching:
            return "가르치고 있습니다."
        case .praying:
            return "기도하고 있습니다."
        }
    }
}
