import SwiftUI

struct AppTheme {
    struct Colors {
        let primary = Color(red: 0, green: 122/255, blue: 255/255)
        let success = Color(red: 52/255, green: 199/255, blue: 89/255)
        let warning = Color(red: 255/255, green: 204/255, blue: 0)
        let danger = Color(red: 255/255, green: 59/255, blue: 48/255)
        let backgroundLight = Color.white
        let backgroundDark = Color.black
        let textLight = Color.black
        let textDark = Color.white
        let caption = Color(red: 142/255, green: 142/255, blue: 147/255)
    }
    
    struct Typography {
        struct Heading {
            let font = Font.system(size: 34, weight: .bold)
            let fontSize: CGFloat = 34  // 추가
            let lineHeight: CGFloat = 41
        }
        
        struct Body {
            let font = Font.system(size: 17)
            let fontSize: CGFloat = 17  // 추가
            let lineHeight: CGFloat = 22
        }
        
        struct Button {
            let font = Font.system(size: 17, weight: .semibold)
            let fontSize: CGFloat = 17  // 추가
            let lineHeight: CGFloat = 22
        }
        
        struct Caption {
            let font = Font.system(size: 13)
            let fontSize: CGFloat = 13  // 추가
            let lineHeight: CGFloat = 18
        }
    }
    
    let colors = Colors()
    let typography = Typography()
    
    // 타이포그래피 스타일 접근을 위한 편의 메서드
    func heading() -> Typography.Heading {
        return Typography.Heading()
    }
    
    func body() -> Typography.Body {
        return Typography.Body()
    }
    
    func button() -> Typography.Button {
        return Typography.Button()
    }
    
    func caption() -> Typography.Caption {
        return Typography.Caption()
    }
}

// 전역 테마 인스턴스
let theme = AppTheme()
