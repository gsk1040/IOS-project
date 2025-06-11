import SwiftUI

struct AppTheme {
    struct Colors {
        let primary = Color.blue
        let success = Color.green
        let warning = Color.orange
        let danger = Color.red
        let backgroundLight = Color(UIColor.systemGroupedBackground)
        let backgroundDark = Color.black
        let textLight = Color.primary
        let textDark = Color.primary
        let caption = Color.secondary
    }
    
    // [오류 수정 완료] 뷰에서 바로 접근 가능하도록 인스턴스가 아닌 타입 자체로 변경합니다.
    struct Typography {
        let heading = Font.system(size: 34, weight: .bold)
        let body = Font.system(size: 17)
        let button = Font.system(size: 17, weight: .semibold)
        let caption = Font.system(size: 13)
    }
    
    let colors = Colors()
    let typography = Typography()
}

// 전역 테마 인스턴스
let theme = AppTheme()
