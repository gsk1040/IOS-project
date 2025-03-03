//
//  AppTheme.swift
//  MovieMate
//
//  Created by 원대한 on 3/3/25.
//


// AppTheme.swift 파일 생성
import UIKit

struct AppTheme {
    static let primary = UIColor(hex: "#FF69B4") // Hot Pink
    static let secondary = UIColor(hex: "#4682B4") // Steel Blue
    static let accent = UIColor(hex: "#FFD700") // Gold
    static let background = UIColor(hex: "#F0F8FF") // Alice Blue
    static let textDark = UIColor(hex: "#333333")
    static let textLight = UIColor(hex: "#777777")
    static let separator = UIColor(hex: "#DDDDDD")
    
    // UIColor 확장 추가
    static func gradientLayer(colors: [UIColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradient
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                 alpha: 1.0)
    }
}
