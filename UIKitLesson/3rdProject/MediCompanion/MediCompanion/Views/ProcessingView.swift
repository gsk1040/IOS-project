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
    
    var body: some View {
        VStack(spacing: 40) {
            Text("검진표 분석 중...")
                .font(AppTheme.Typography.Heading().font)
                .foregroundStyle(theme.colors.textLight)
            
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
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: progress)
                    .onAppear {
                        progress = 1.0
                    }
            }
            
            Text("잠시만 기다려주세요...")
                .font(AppTheme.Typography.Body().font)
                .foregroundStyle(theme.colors.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.backgroundLight)
        .onAppear {
            // 프로토타입에서는 3초 후 결과 화면으로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appState.remainingScans -= 1
                appState.navigateTo(.result)
            }
        }
    }
}
