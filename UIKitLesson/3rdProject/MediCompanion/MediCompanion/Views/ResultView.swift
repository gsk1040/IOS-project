import SwiftUI

struct ResultView: View {
    @EnvironmentObject var appState: AppState
    
    // 샘플 건강 데이터 (실제 앱에서는 API 또는 이미지 분석 결과로 대체)
    let healthData = [
        HealthItem(title: "혈압", value: "120/80 mmHg", interpretation: "정상 범위입니다. 건강한 혈압을 유지하고 계세요!", status: .normal),
        HealthItem(title: "공복혈당", value: "95 mg/dL", interpretation: "정상 범위입니다. 건강한 혈당 수준을 유지하고 계세요!", status: .normal),
        HealthItem(title: "총 콜레스테롤", value: "210 mg/dL", interpretation: "경계 수준입니다. 식이 조절과 운동을 통해 관리하세요.", status: .warning),
        HealthItem(title: "LDL 콜레스테롤", value: "140 mg/dL", interpretation: "경계 수준입니다. 식이 조절과 운동을 통해 관리하세요.", status: .warning)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 상단 요약
                VStack(alignment: .leading, spacing: 8) {
                    Text("검진 결과 요약")
                        .font(AppTheme.Typography.Heading().font)
                        .foregroundStyle(theme.colors.textLight)
                    
                    Text("전반적인 건강 상태는 양호하나, 콜레스테롤 수치가 경계 수준입니다. 정기적인 건강 관리와 식이 조절을 권장합니다.")
                        .font(AppTheme.Typography.Body().font)
                        .foregroundStyle(theme.colors.textLight)
                        .padding()
                        .background(theme.colors.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // 상세 건강 지표
                ForEach(healthData) { item in
                    HealthItemView(item: item)
                }
                
                // 면책 조항
                Text("* 본 정보는 참고용이며, 정확한 의학적 판단은 의사와 상담하세요.")
                    .font(AppTheme.Typography.Caption().font)
                    .foregroundStyle(theme.colors.caption)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // 건강 도우미와 대화하기 버튼 (NavigationLink)
                NavigationLink(destination: ChatView()) {
                    HStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 20))
                        Text("건강 도우미와 대화하기")
                            .font(AppTheme.Typography.Button().font)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.colors.primary)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding(.vertical, 24)
        }
        .navigationBarTitle("분석 결과", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                appState.navigateToRoot()
            }) {
                Text("완료")
                    .font(AppTheme.Typography.Button().font)
                    .foregroundStyle(theme.colors.primary)
            }
        )
        .background(theme.colors.backgroundLight)
    }
}

// 건강 상태 열거형
enum HealthStatus {
    case normal
    case warning
    case danger
    
    var color: Color {
        switch self {
        case .normal: return theme.colors.success
        case .warning: return theme.colors.warning
        case .danger: return theme.colors.danger
        }
    }
    
    var iconName: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .danger: return "xmark.circle.fill"
        }
    }
}

// 건강 항목 모델
struct HealthItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let interpretation: String
    let status: HealthStatus
}

// 건강 항목 뷰
struct HealthItemView: View {
    let item: HealthItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: item.status.iconName)
                    .foregroundColor(item.status.color)
                    .font(.system(size: 22))
                
                Text(item.title)
                    .font(AppTheme.Typography.Button().font)
                    .foregroundStyle(theme.colors.textLight)
            }
            
            HStack {
                Text("측정값:")
                    .font(AppTheme.Typography.Body().font)
                    .foregroundStyle(theme.colors.caption)
                
                Spacer()
                
                Text(item.value)
                    .font(AppTheme.Typography.Body().font)
                    .foregroundStyle(theme.colors.textLight)
                    .fontWeight(.medium)
            }
            
            Text(item.interpretation)
                .font(AppTheme.Typography.Body().font)
                .foregroundStyle(theme.colors.textLight)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
