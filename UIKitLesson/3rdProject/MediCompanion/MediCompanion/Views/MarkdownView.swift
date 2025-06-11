//
//  MarkdownView.swift
//  MediCompanion
//
//  Created by Gemini on 6/12/25.
//

import SwiftUI

/// 레이아웃과 스타일링을 분리하여 마크다운을 안정적으로 렌더링하는 최종 버전의 뷰입니다.
struct MarkdownView: View {
    let text: String
    let foregroundColor: Color
    let accentColor: Color

    var body: some View {
        // 1. 텍스트를 '빈 줄' 기준으로 문단으로 나눕니다.
        // 이렇게 하면 "다닥다닥 붙는" 문제가 근본적으로 해결됩니다.
        let paragraphs = text.components(separatedBy: "\n\n")

        // 2. 각 문단을 VStack을 이용해 수직으로 쌓아, 문단 간의 간격을 만듭니다.
        VStack(alignment: .leading, spacing: 16) {
            ForEach(paragraphs, id: \.self) { paragraph in
                // 3. 각 문단을 개별적으로 렌더링하는 하위 뷰를 호출합니다.
                ParagraphView(
                    paragraph: paragraph,
                    foregroundColor: foregroundColor,
                    accentColor: accentColor
                )
            }
        }
    }
}

/// 단일 마크다운 문단을 렌더링하는 내부 뷰
private struct ParagraphView: View {
    let paragraph: String
    let foregroundColor: Color
    let accentColor: Color

    var body: some View {
        // 이 뷰는 오직 한 문단의 '내용'에만 집중합니다.
        // 네이티브 파서를 사용하여 굵은 글씨, 링크 등의 스타일을 적용합니다.
        Text(createAttributedString())
            .font(.body) // 전체 텍스트에 일관된 기본 폰트 크기를 적용합니다.
            .lineSpacing(5) // 줄 간격을 살짝 넓혀 가독성을 높입니다.
    }
    
    /// 한 문단의 텍스트를 받아, 스타일이 적용된 AttributedString을 생성합니다.
    private func createAttributedString() -> AttributedString {
        // 우리 앱만의 특수한 문법인 (출처)를 표준 마크다운 링크로 먼저 변환합니다.
        let processedMarkdown = preprocessForCustomSyntax(paragraph)

        do {
            // SwiftUI의 강력한 네이티브 마크다운 파서를 사용합니다.
            var attributedString = try AttributedString(markdown: processedMarkdown)
            
            // 전체 텍스트에 기본 색상을 적용합니다.
            attributedString.foregroundColor = foregroundColor
            
            // 파싱된 결과에서 링크 부분만 찾아 추가 스타일(색상, 밑줄)을 적용합니다.
            for run in attributedString.runs where run.link != nil {
                attributedString[run.range].foregroundColor = accentColor
                attributedString[run.range].underlineStyle = .single
            }
            
            return attributedString
            
        } catch {
            // 파싱에 실패하면 일반 텍스트로 안전하게 표시합니다.
            var fallback = AttributedString(paragraph)
            fallback.foregroundColor = foregroundColor
            return fallback
        }
    }

    /// '(출처N)'과 같은 앱 고유의 문법을 표준 마크다운 링크로 변환하는 전처리기
    private func preprocessForCustomSyntax(_ rawText: String) -> String {
        var processed = rawText
        let pattern = "\\(출처(\\d+)\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return rawText }
        
        let matches = regex.matches(in: rawText, range: NSRange(rawText.startIndex..., in: rawText))

        for match in matches.reversed() {
            guard let fullRange = Range(match.range(at: 0), in: processed),
                  let numberRange = Range(match.range(at: 1), in: processed) else { continue }
            
            let number = String(processed[numberRange])
            let fullText = String(processed[fullRange])
            
            // e.g., "(출처8)" -> "[(출처8)](source://8)"
            let markdownLink = "[\(fullText)](source://\(number))"
            processed.replaceSubrange(fullRange, with: markdownLink)
        }
        
        return processed
    }
}
