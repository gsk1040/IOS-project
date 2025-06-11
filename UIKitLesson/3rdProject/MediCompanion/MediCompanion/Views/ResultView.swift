//
//  ResultView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/11/25.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedItem: HealthItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ResultSummaryView(healthData: appState.healthData ?? [])
                
                if let healthData = appState.healthData, !healthData.isEmpty {
                    ForEach(healthData) { item in
                        HealthItemView(item: item) {
                            self.selectedItem = item
                        }
                    }
                } else {
                    Text("분석된 건강 데이터가 없습니다.").padding()
                }
                
                Text("* 본 정보는 참고용이며, 정확한 의학적 판단은 의사와 상담하세요.")
                    .font(.caption).foregroundColor(.secondary).padding(.horizontal)
                
                NavigationLink(destination: ChatView()) {
                    Label("건강 도우미와 대화하기", systemImage: "bubble.left.and.bubble.right.fill")
                        .font(theme.typography.button) // [오류 수정 완료]
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.colors.primary)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("분석 결과")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(item: $selectedItem) { item in
            // TODO: RecommendedVideoSummaryView를 여기에 구현해야 합니다.
            Text("\(item.title)에 대한 추천 영상 요약 뷰").padding()
        }
    }
}

struct ResultSummaryView: View {
    let healthData: [HealthItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("검진 결과 요약").font(theme.typography.heading) // [오류 수정 완료]
            Text(generateSummary())
                .padding()
                .background(theme.colors.primary.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    private func generateSummary() -> String {
        guard !healthData.isEmpty else { return "분석할 데이터가 없습니다." }
        let warningCount = healthData.filter { $0.status == .warning }.count
        let dangerCount = healthData.filter { $0.status == .danger }.count
        
        if dangerCount > 0 { return "**주의가 필요한 항목이 \(dangerCount)개 있습니다.** 의사와 상담하세요." }
        if warningCount > 0 { return "**일부 항목에 주의가 필요합니다.** 생활 습관 개선을 고려하세요." }
        return "**전반적인 건강 상태가 양호합니다.** 현재의 건강 관리를 유지하세요."
    }
}

struct HealthItemView: View {
    let item: HealthItem
    var onRecommendationTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // [오류 수정 완료] item.status.iconName -> item.status.icon
                Label(item.title, systemImage: item.status.icon)
                    .font(theme.typography.button) // [오류 수정 완료]
                    .foregroundColor(item.status.color)
                Spacer()
                if item.status != .normal {
                    Button(action: onRecommendationTap) {
                        Image(systemName: "film.circle.fill")
                            .font(.system(size: 24))
                    }.buttonStyle(.borderless)
                }
            }
            HStack {
                Text("측정값:").foregroundColor(.secondary)
                Spacer()
                Text(item.value).fontWeight(.medium)
            }
            if let range = item.referenceRange {
                HStack {
                    Text("참고범위:").foregroundColor(.secondary)
                    Spacer()
                    Text(range)
                }
            }
            Text(item.interpretation).padding(.top, 5)
        }
        .font(.subheadline)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
