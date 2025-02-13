import Cocoa


// MARK: - ASCII 아트 모듈
struct BibleEEArt {
    static let temple = """
        🏛️🔌
         _|_|_  
        |⚡️⚡️⚡️| 
        |__+__|
        """
    
    static let figTree = """
        🌳💡
          /\\
         /  \\
        /🍃%@🍃\\
        """
}

// MARK: - 게임 시작 화면
func showTitle() {
    print("""
    ============================
    🙏 누가복음 21장 전기기사 게임
    ⚡️ Enter로 시작! (1~5 선택)
    ============================
    """)
}

// MARK: - 미니 게임 1: 과부의 헌금 시뮬레이션
func widowGame() {
    print("\n[과부의 두 렙돈 헌금 VR]")
    print("생활비를 얼마나 드리시겠습니까? (단위: 데나리온)", terminator: " ")
    guard let input = readLine(), let livingCost = Double(input) else {
        print("⚠️ 숫자만 입력하세요!")
        return
    }
    
    let offering = Int.random(in: 1...100)
    let voltage = livingCost * Double(offering) * 0.01
    print("\n⚡️ 헌금 전압 생성 중...")
    (0...Int(voltage)).forEach { _ in print("-", terminator: "") }
    print("\n생성된 전압: \(String(format: "%.1f", voltage))V")
    print(voltage >= 2.0 ? "🎉 예수님이 '참 헌금'이라고 하십니다!" : "😭 더 작은 소액을 드리셨네요...")
}

// MARK: - 미니 게임 2: 성전 과부하 파괴 게임
func templeGame() {
    print("\n\(BibleEEArt.temple)")
    print("[성전 전력 관리 게임]")
    print("허용 전류 10A, 전력(W)을 입력하세요:", terminator: " ")
    
    guard let input = readLine(), let power = Double(input) else {
        print("⚡️ 숫자만 써주세요!")
        return
    }
    
    let result = power / 15.0 > 10.0
    print(result ? "💥 성전이 무너집니다! (A.D.70)" : "🛡️ 안전하게 보존되었습니다!")
    if result { print("🔥 로마군이 쳐들어옵니다! 🔥") }
}

// MARK: - 미니 게임 3: 종말 징조 선택기
func apocalypseGame() {
    print("\n[종말의 징조 선택]")
    print("""
    1. 🌑 해가 어두워짐
    2. 🌕 달이 핏빛
    3. 🌠 별이 떨어짐
    """)
    
    guard let choice = readLine(), let num = Int(choice) else { return }
    
    let alert = [
        "태양광 발전기 고장!",
        "야간 조명 수요 폭증!",
        "위성 전력망 붕괴!"
    ][num-1]
    
    print("\n🚨 \(alert)")
    print("(눅 21:25-26) 사람들이...")
    DispatchQueue.global().async {
        (1...3).forEach { _ in
            print("💥", terminator: "")
            usleep(300000)
        }
        print("\n")
    }
}

// MARK: - 메인 실행 루프
while true {
    showTitle()
    guard let input = readLine(), let menu = Int(input) else { continue }
    
    switch menu {
    case 1: widowGame()
    case 2: templeGame()
    case 3: apocalypseGame()
    case 4:
        print("\n🌳 무화과나무 예방 정비")
        print("잎사귀 수 입력:", terminator: " ")
        let leaves = Int(readLine() ?? "") ?? 0
        print(leaves >= 10 ? "🍃 여름이 가까우니 안전!" : "🔧 긴급 점검 필요!")
    case 5:
        print("\n🚪 게임 종료")
        exit(0)
    default: break
    }
    
    sleep(1)
    print("\n\n")
}

