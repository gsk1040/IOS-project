import SwiftUI
import Combine

// API로부터 받아올 JSON 데이터 모델 정의
// JSON 구조: [{"id": 1, "name": "Leanne Graham"}, ...]
struct User: Decodable, Identifiable {
    var id: Int       // 사용자 고유 ID
    var name: String  // 사용자 이름
}

// Combine을 활용한 사용자 데이터 관리 ViewModel
class UserViewModel: ObservableObject {
    @Published var users: [User] = []  // UI에 반영할 사용자 목록

        // 구독 취소를 위한 저장소
    private var cancellables = Set<AnyCancellable>()

    func fetchUsers() {
        // API URL 생성
        guard
            let url =
            URL(string: "https://jsonplaceholder.typicode.com/users")
          else { return }

        // URLSession의 Combine Publisher 사용
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)  // (data, response)에서 data만 추출
            // JSON → [User]로 디코딩
            .decode(type: [User].self, decoder: JSONDecoder())
            .replaceError(with: [])  // 실패 시 빈 배열로 대체 (에러 무시)
            // 결과를 메인 스레드에서 전달 (UI 업데이트용)
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)  // 결과를 @Published users에 바인딩
    }
}

// 사용자 리스트를 보여주는 SwiftUI 뷰
struct UserListView: View {
        // ViewModel을 한 번 생성 후 상태 유지
    @StateObject var viewModel = UserViewModel()
    var body: some View {
        List(viewModel.users) { user in
                // 각 사용자 이름을 출력
            Text(user.name)
        }
        .onAppear {
                // 뷰가 나타날 때 API 호출 시작
            viewModel.fetchUsers()
        }
    }
}
#Preview {
    UserListView()
}
