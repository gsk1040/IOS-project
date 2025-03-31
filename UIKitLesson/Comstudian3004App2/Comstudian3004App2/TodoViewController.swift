import UIKit

class TodoViewController: UIViewController {
    // 할 일 목록을 표시할 테이블 뷰
    private let tableView = UITableView()
    
    // Firestore에서 가져온 할 일 목록 데이터를 저장할 배열
    private var todos: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 구성 함수 호출
        setupUI()
        // Firestore에서 데이터를 가져오는 함수 호출
        fetchTodos()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "할 일 목록"

        // 네비게이션 바에 할 일 추가 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addTodo)
        )

        // 테이블 뷰 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Auto Layout을 적용하여 테이블 뷰가 화면 전체를 차지하도록 설정
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Firestore에서 할 일 목록을 가져오는 함수
    private func fetchTodos() {
        FirestoreManager.shared.fetchTodos { [weak self] todos, error in
            guard let self = self else { return }
            if let error = error {
                print("Firestore에서 데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.todos = todos ?? []  // 가져온 데이터를 todos 배열에 저장
                print("Firestore에서 \(self.todos.count)개의 데이터를 가져옴.")
                self.tableView.reloadData() // UI 갱신
            }
        }
    }

    // 새로운 할 일을 추가하는 함수
    @objc private func addTodo() {
        let alert = UIAlertController(title: "할 일 추가", message: "새로운 할 일을 입력하세요.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "할 일 입력"
            textField.keyboardType = .default
        }

        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            guard let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty else {
                return
            }
            FirestoreManager.shared.addTodo(title: text) { _ in
                DispatchQueue.main.async {
                    self.fetchTodos() // Firestore에 추가 후 목록 다시 불러오기
                }
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        // UIWindow를 이용해 UIAlertController 표시
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            DispatchQueue.main.async {
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Firestore에 데이터가 없는 경우 기본 데이터 추가
    @objc private func addInitialDataIfNeeded() {
        FirestoreManager.shared.fetchTodos { [weak self] todos, error in
            guard let self = self else { return }
            if todos?.isEmpty ?? true {  // Firestore에 데이터가 없는 경우
                print("Firestore에 데이터가 없어 기본 데이터 추가")
                FirestoreManager.shared.addTodo(title: "첫 번째 할 일") { _ in self.fetchTodos() }
            }
        }
    }
}

// UITableViewDataSource와 UITableViewDelegate 구현
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    // 할 일 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    // 각 셀에 할 일 데이터 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.isCompleted ? .checkmark : .none // 완료된 경우 체크 표시
        return cell
    }

    // 할 일 클릭 시 완료 상태 업데이트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        FirestoreManager.shared.updateTodo(todo: todo) { _ in self.fetchTodos() }
    }

    // 할 일 삭제 기능 구현
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = todos[indexPath.row].id
            FirestoreManager.shared.deleteTodo(id: id) { _ in self.fetchTodos() }
        }
    }
}
