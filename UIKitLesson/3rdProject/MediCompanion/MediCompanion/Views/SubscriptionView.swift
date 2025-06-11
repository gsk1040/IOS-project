//
//  SubscriptionView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/5/25.
//


// Views/SubscriptionView.swift
import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("무료 스캔을 모두 사용하셨어요")
                .font(theme.typography.heading)
                .foregroundStyle(theme.colors.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // 구독 플랜 (프로토타입용 더미 데이터)
            VStack(spacing: 16) {
                SubscriptionPlanView(
                    title: "월간 구독",
                    price: "₩4,900",
                    description: "매월 무제한 스캔",
                    isHighlighted: true
                )
                
                SubscriptionPlanView(
                    title: "연간 구독",
                    price: "₩49,000",
                    description: "매월 무제한 스캔 (16% 할인)",
                    isHighlighted: false
                )
            }
            
            // 하단 버튼
            Button(action: {
                appState.navigateToRoot()
            }) {
                Text("메인으로 돌아가기")
                    .font(theme.typography.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.colors.primary)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Text("구독은 언제든지 취소할 수 있습니다")
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.backgroundLight)
    }
}

// 구독 플랜 컴포넌트
struct SubscriptionPlanView: View {
    let title: String
    let price: String
    let description: String
    let isHighlighted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(theme.typography.button)
                .foregroundStyle(isHighlighted ? theme.colors.primary : theme.colors.textLight)
            
            HStack(alignment: .firstTextBaseline) {
                Text(price)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.textLight)
                
                Spacer()
                
                if isHighlighted {
                    Text("추천")
                        .font(theme.typography.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(theme.colors.primary)
                        .cornerRadius(4)
                }
            }
            
            Text(description)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isHighlighted ? theme.colors.primary : Color.gray.opacity(0.3), lineWidth: isHighlighted ? 2 : 1)
        )
        .padding(.horizontal)
    }
}
