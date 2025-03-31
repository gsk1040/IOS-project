import UIKit

class ProfileViewController: UIViewController {
    // MARK: - 프로퍼티
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // 상단 프로필 정보
    private let profileInfoContainer = UIView()
    private let profileImageView = UIImageView()
    private let statusIndicator = UIView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let locationLabel = UILabel()
    private let editProfileButton = UIButton(type: .system)

    // 내부 탭 관련
    private let tabContainerView = UIView()
    private let segmentedControl = UISegmentedControl(items: ["프로필", "감정통계", "플레이리스트"])
    private let containerView = UIView()  // 선택된 탭 콘텐츠를 표시할 뷰

    // 내부 탭의 뷰 컨트롤러들
    private lazy var profileContentVC = ProfileContentViewController()
    private lazy var emotionStatsVC = EmotionStatsViewController()
    private lazy var playlistVC = PlaylistViewController()
    private var currentViewController: UIViewController?

    // 사용자 데이터
    private var name = ""
    private var username = ""
    private var bio = ""
    private var location = ""
    private var genres: [String] = []

    // MARK: - 라이프사이클 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        layoutUI()

        // 기본 탭 선택
        segmentedControl.selectedSegmentIndex = 0
        switchTab(to: 0)
    }

    // MARK: - 셋업 메서드
    private func setup() {
        view.backgroundColor = UIColor(
            red: 245 / 255, green: 247 / 255, blue: 250 / 255, alpha: 0.95)
        title = "사용자"

        let editButton = UIBarButtonItem(
            title: "편집", style: .plain, target: self, action: #selector(editProfileTapped))
        navigationItem.rightBarButtonItem = editButton
        
        // UserDefaults에서 데이터 로드
        loadProfileData()
    }
    
    // UserDefaults에서 프로필 데이터 로드
    private func loadProfileData() {
        let userDefaults = UserDefaultsManager.shared
        name = userDefaults.getName()
        username = userDefaults.getUsername()
        bio = userDefaults.getBio()
        location = userDefaults.getLocation()
        genres = userDefaults.getGenres()
    }

    private func setupUI() {
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 프로필 이미지 설정
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill

        // 온라인 상태 인디케이터
        statusIndicator.backgroundColor = UIColor(
            red: 76 / 255, green: 175 / 255, blue: 80 / 255, alpha: 1)
        statusIndicator.layer.cornerRadius = 7
        statusIndicator.layer.borderWidth = 2
        statusIndicator.layer.borderColor = UIColor.white.cgColor

        // 이름 라벨
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 1)

        // 사용자 이름 라벨
        usernameLabel.text = username
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.textColor = UIColor(
            red: 127 / 255, green: 140 / 255, blue: 141 / 255, alpha: 1)

        // 소개 라벨
        bioLabel.text = bio
        bioLabel.font = UIFont.systemFont(ofSize: 16)
        bioLabel.textColor = UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 1)

        // 위치 라벨
        locationLabel.text = location
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = UIColor(
            red: 127 / 255, green: 140 / 255, blue: 141 / 255, alpha: 1)

        // 프로필 편집 버튼
        editProfileButton.setTitle("프로필 편집", for: .normal)
        editProfileButton.backgroundColor = UIColor(
            red: 240 / 255, green: 242 / 255, blue: 245 / 255, alpha: 1)
        editProfileButton.setTitleColor(
            UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 1), for: .normal)
        editProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)

        // 세그먼트 컨트롤 설정
        segmentedControl.selectedSegmentTintColor = UIColor(
            red: 88 / 255, green: 126 / 255, blue: 255 / 255, alpha: 1)

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

        // 컨테이너 뷰 설정
        containerView.backgroundColor = .clear

        // 각 컨테이너 추가
        contentView.addSubview(profileInfoContainer)
        profileInfoContainer.addSubview(profileImageView)
        profileInfoContainer.addSubview(statusIndicator)
        profileInfoContainer.addSubview(nameLabel)
        profileInfoContainer.addSubview(usernameLabel)
        profileInfoContainer.addSubview(editProfileButton)

        contentView.addSubview(bioLabel)
        contentView.addSubview(locationLabel)

        contentView.addSubview(tabContainerView)
        tabContainerView.addSubview(segmentedControl)
        tabContainerView.addSubview(containerView)
    }

    // MARK: - 레이아웃 메서드
    private func layoutUI() {
        // 기존 레이아웃 코드 유지
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        profileInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 스크롤뷰 제약조건
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // 콘텐츠뷰 제약조건
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // 프로필 정보 컨테이너
            profileInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileInfoContainer.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 20),
            profileInfoContainer.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),

            // 프로필 이미지
            profileImageView.topAnchor.constraint(equalTo: profileInfoContainer.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileInfoContainer.leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),

            // 상태 인디케이터
            statusIndicator.bottomAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: -2),
            statusIndicator.trailingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: -2),
            statusIndicator.heightAnchor.constraint(equalToConstant: 14),
            statusIndicator.widthAnchor.constraint(equalToConstant: 14),

            // 이름 라벨
            nameLabel.topAnchor.constraint(equalTo: profileInfoContainer.topAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 15),

            // 사용자 이름 라벨
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            // 편집 버튼
            editProfileButton.centerYAnchor.constraint(equalTo: profileInfoContainer.centerYAnchor),
            editProfileButton.trailingAnchor.constraint(
                equalTo: profileInfoContainer.trailingAnchor),

            // 프로필 컨테이너 높이
            profileInfoContainer.heightAnchor.constraint(equalToConstant: 80),

            // 자기 소개
            bioLabel.topAnchor.constraint(equalTo: profileInfoContainer.bottomAnchor, constant: 16),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // 위치
            locationLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),

            // 탭 컨테이너
            tabContainerView.topAnchor.constraint(
                equalTo: locationLabel.bottomAnchor, constant: 24),
            tabContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tabContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tabContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // 세그먼트 컨트롤
            segmentedControl.topAnchor.constraint(equalTo: tabContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(
                equalTo: tabContainerView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(
                equalTo: tabContainerView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            // 컨테이너 뷰
            containerView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor),
            // 컨테이너 뷰 높이 (필요에 따라 조정)
            containerView.heightAnchor.constraint(equalToConstant: 500),
        ])
    }

    // MARK: - 탭 전환 메서드
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switchTab(to: sender.selectedSegmentIndex)
    }

    private func switchTab(to index: Int) {
        // 현재 표시된 뷰 컨트롤러 제거
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        // 새 뷰 컨트롤러 표시
        let newVC: UIViewController
        switch index {
        case 0:
            newVC = profileContentVC
        case 1:
            newVC = emotionStatsVC
        case 2:
            newVC = playlistVC
        default:
            newVC = profileContentVC
        }

        addChild(newVC)
        newVC.view.frame = containerView.bounds
        containerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)

        // 자식 뷰 컨트롤러의 뷰가 컨테이너 뷰의 크기에 맞도록 설정
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        currentViewController = newVC
    }

    // MARK: - 액션 메서드
    @objc private func editProfileTapped() {
        let profileEditVC = ProfileEditViewController()
        profileEditVC.delegate = self
        let navController = UINavigationController(rootViewController: profileEditVC)
        present(navController, animated: true)
    }
}

// MARK: - ProfileEditViewControllerDelegate
extension ProfileViewController: ProfileEditViewControllerDelegate {
    func didUpdateProfile(name: String, genres: [String]) {
        self.name = name
        self.genres = genres

        // UI 업데이트
        nameLabel.text = name
        profileContentVC.updateGenres(genres)
        
        // UserDefaults에 저장
        UserDefaultsManager.shared.saveProfile(name: name, genres: genres)
    }
}
#Preview {
    ProfileEditViewController()
}
