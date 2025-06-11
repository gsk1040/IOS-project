//
//  OCRProcessor.swift
//  MediCompanion
//
//  Created by 원대한 on 6/11/25.
//


//
//  OCRProcessor.swift
//  MediCompanion
//
//  Created by Gemini on 6/12/25.
//

import Foundation
import Vision
import UIKit

class OCRProcessor: ObservableObject {
    
    enum OCRError: Error, LocalizedError {
        case noTextFound
        case recognitionFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .noTextFound:
                return "이미지에서 텍스트를 찾을 수 없습니다."
            case .recognitionFailed(let message):
                return "텍스트 인식 실패: \(message)"
            }
        }
    }

    /// 이미지에서 텍스트를 비동기적으로 추출합니다.
    func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.recognitionFailed("유효하지 않은 이미지 형식입니다.")
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate // 정확도 우선
        
        return try await withCheckedThrowingContinuation { continuation in
            request.recognitionLanguages = ["ko-KR", "en-US"]
            
            do {
                try requestHandler.perform([request])
                guard let observations = request.results, !observations.isEmpty else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let recognizedText = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")
                
                continuation.resume(returning: recognizedText)
                
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
            }
        }
    }
    
    /// 추출된 텍스트에서 건강 항목들을 파싱합니다. (정규식 기반)
    func parseHealthItems(from text: String) -> [HealthItem] {
        // TODO: 정규표현식을 사용하여 텍스트에서 건강 데이터를 추출하는 로직 구현 필요
        // 이 부분은 검진표 형식에 따라 매우 복잡하고 정교한 패턴 매칭이 필요합니다.
        // 아래는 예시 데이터입니다.
        
        return [
            HealthItem(title: "총 콜레스테롤", value: "210 mg/dL", interpretation: "경계 수준입니다. 식이 조절과 운동을 통해 관리하세요.", status: .warning, referenceRange: "< 200"),
            HealthItem(title: "HDL 콜레스테롤", value: "35 mg/dL", interpretation: "정상보다 낮습니다. 운동을 통해 수치를 높일 수 있습니다.", status: .warning, referenceRange: "40-60"),
            HealthItem(title: "공복혈당", value: "95 mg/dL", interpretation: "정상 범위입니다. 건강한 혈당 수준을 유지하고 계세요!", status: .normal, referenceRange: "70-99")
        ]
    }
}
