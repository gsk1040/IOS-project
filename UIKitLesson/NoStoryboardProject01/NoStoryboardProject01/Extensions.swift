//
//  Extensions.swift
//  NoStoryboardProject01
//
//  Created by 원대한 on 3/17/25.
//
import UIKit

// UIEdgeInsets 확장 - 패딩을 위한 헬퍼 메서드
extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

// UIColor 확장 - 앱에서 자주 사용하는 색상 정의
extension UIColor {
    static let primaryBlue = UIColor(red: 88/255, green: 126/255, blue: 255/255, alpha: 1)
    static let primaryBlueTint = UIColor(red: 88/255, green: 126/255, blue: 255/255, alpha: 0.1)
    static let textPrimary = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
    static let textSecondary = UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1)
    static let backgroundPrimary = UIColor(red: 245/255, green: 247/255, blue: 250/255, alpha: 0.95)
}

// UIView 확장 - 그림자 효과를 쉽게 추가하기 위한 메서드
extension UIView {
    func addShadow(offset: CGSize = CGSize(width: 0, height: 4),
                   color: UIColor = .black,
                   opacity: Float = 0.15,
                   radius: CGFloat = 12) {
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

// String 확장 - 감정 관련 이모지 가져오기
extension String {
    static func emojiForEmotion(_ emotion: String) -> String {
        switch emotion.lowercased() {
        case "행복": return "😊"
        case "슬픔": return "😔"
        case "화남": return "😠"
        case "평온": return "😌"
        default: return "🎵"
        }
    }
}

// UIViewController 확장 - 간단한 알림창 표시
extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "확인") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }
}
