//
//  ProcessingView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/5/25.
//


// Views/ProcessingView.swift
import SwiftUI

struct ProcessingView: View {
    @EnvironmentObject var appState: AppState
    @State private var progress: Double = 0
    
    // [개선] OCR 분석 상태를 보여주기 위한 상태 변수 추가
    @State private var statusDetail: String = "텍스트 인식 준비 중..."
    @State private var errorMessage: String? = nil
    
    // [개선] 실제 OCR 처리를 위한 뷰모델
    @StateObject private var ocrProcessor = OCRProcessor()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("검진표 분석 중...")
                // [오류 수정 완료] .font(AppTheme.Typography.Heading().font) -> .font(theme.typography.heading)
                .font(theme.typography.heading)
                .foregroundStyle(theme.colors.textLight)
                .multilineTextAlignment(.center)
            
            // 회전하는 원형 프로그레스 인디케이터
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .opacity(0.3)
                    .foregroundColor(theme.colors.primary)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(theme.colors.primary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(Angle(degrees: 360 * progress))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: progress)
                    .onAppear {
                        progress = 1.0
                    }
            }
            
            // [개선] 현재 처리 단계를 보여주는 텍스트
            Text(statusDetail)
                // [오류 수정 완료] .font(AppTheme.Typography.Body().font) -> .font(theme.typography.body)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // [개선] 오류 발생 시 메시지와 재시도 버튼 표시
            if let error = errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.danger)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("다시 시도") {
                        appState.navigateBack() // 이전 카메라 화면으로 돌아가기
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(theme.colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            // [개선] 3초 타이머 대신 실제 이미지 처리 함수를 호출합니다.
            processImage()
        }
    }
    
    /// 캡처된 이미지를 가져와 OCR 및 데이터 파싱을 수행하는 함수
    private func processImage() {
        guard let image = appState.capturedImage else {
            errorMessage = "분석할 이미지를 찾을 수 없습니다."
            return
        }
        
        Task {
            do {
                // 1. OCR로 텍스트 추출
                await MainActor.run { statusDetail = "텍스트 인식 중..." }
                let extractedText = try await ocrProcessor.recognizeText(from: image)
                
                // 텍스트가 너무 적으면 오류 처리
                if extractedText.count < 20 {
                    throw OCRProcessor.OCRError.noTextFound
                }
                
                // 2. 건강 데이터 파싱
                await MainActor.run { statusDetail = "건강 데이터 분석 중..." }
                var healthItems = ocrProcessor.parseHealthItems(from: extractedText)
                
                // 원시 OCR 텍스트 저장 (디버깅 및 개선용)
                for i in 0..<healthItems.count {
                    healthItems[i].rawOCRText = extractedText
                }
                
                // 3. 앱 상태에 건강 데이터 저장
                await MainActor.run {
                    appState.saveHealthData(healthItems)
                    // 4. 결과 화면으로 이동
                    appState.navigateTo(.result)
                }
                
            } catch let ocrError as OCRProcessor.OCRError {
                switch ocrError {
                case .noTextFound:
                    errorMessage = "이미지에서 충분한 텍스트를 인식할 수 없습니다. 더 선명한 이미지로 다시 시도해주세요."
                case .recognitionFailed(let message):
                    errorMessage = "텍스트 인식 중 오류가 발생했습니다: \(message)"
                }
            } catch {
                errorMessage = "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
            }
        }
    }
}
