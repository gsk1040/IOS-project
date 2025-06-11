//
//  MarkdownText.swift
//  MediCompanion
//
//  Created by 원대한 on 6/11/25.
//


import SwiftUI

struct MarkdownText: View {
    let text: String
    var foregroundColor: Color?
    var accentColor: Color = .blue
    
    init(_ text: String, foregroundColor: Color? = nil, accentColor: Color = .blue) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            // iOS 15 이상에서는 AttributedString 사용
            attributedText
        } else {
            // iOS 14 이하에서는 일반 텍스트로 표시
            plainText
        }
    }
    
    @available(iOS 15.0, *)
    private var attributedText: some View {
        let attributedString: AttributedString
        
        do {
            // 마크다운을 AttributedString으로 변환
            attributedString = try AttributedString(markdown: text)
        } catch {
            // 변환 실패 시 일반 텍스트로 표시
            return AnyView(Text(text)
                .foregroundColor(foregroundColor)
            )
        }
        
        // 전체 텍스트 색상 지정 (선택 사항)
        var finalAttributedString = attributedString
        if let color = foregroundColor {
            finalAttributedString.foregroundColor = color
        }
        
        return AnyView(
            Text(finalAttributedString)
                .tint(accentColor) // 링크 색상 설정
        )
    }
    
    private var plainText: some View {
        Text(text)
            .foregroundColor(foregroundColor)
    }
}

// 미리보기 제공
struct MarkdownText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 20) {
            MarkdownText("# 제목\n**굵은 글씨**와 *기울임체*\n- 목록 항목\n- 다른 항목\n[링크](https://example.com)")
                .padding()
            
            MarkdownText("일반 텍스트 형식", foregroundColor: .red)
                .padding()
        }
    }
}