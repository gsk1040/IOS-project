//
//  ProfileViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var user: User?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let levelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let experienceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let goldTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "골드"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goldLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemYellow
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.text = "획득한 능력"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skillsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 100, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SkillCell.self, forCellWithReuseIdentifier: SkillCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "프로필"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        
        contentView.addSubview(levelContainer)
        levelContainer.addSubview(levelTitleLabel)
        levelContainer.addSubview(levelLabel)
        levelContainer.addSubview(experienceLabel)
        
        contentView.addSubview(goldContainer)
        goldContainer.addSubview(goldTitleLabel)
        goldContainer.addSubview(goldLabel)
        
        contentView.addSubview(skillsLabel)
        contentView.addSubview(skillsCollectionView)
        contentView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            levelContainer.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 30),
            levelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            levelContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            levelTitleLabel.topAnchor.constraint(equalTo: levelContainer.topAnchor, constant: 15),
            levelTitleLabel.leadingAnchor.constraint(equalTo: levelContainer.leadingAnchor, constant: 15),
            
            levelLabel.topAnchor.constraint(equalTo: levelTitleLabel.bottomAnchor, constant: 5),
            levelLabel.centerXAnchor.constraint(equalTo: levelContainer.centerXAnchor),
            
            experienceLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 5),
            experienceLabel.leadingAnchor.constraint(equalTo: levelContainer.leadingAnchor, constant: 15),
            experienceLabel.trailingAnchor.constraint(equalTo: levelContainer.trailingAnchor, constant: -15),
            experienceLabel.bottomAnchor.constraint(equalTo: levelContainer.bottomAnchor, constant: -15),
            
            goldContainer.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 30),
            goldContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            goldContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            goldContainer.heightAnchor.constraint(equalTo: levelContainer.heightAnchor),
            
            goldTitleLabel.topAnchor.constraint(equalTo: goldContainer.topAnchor, constant: 15),
            goldTitleLabel.leadingAnchor.constraint(equalTo: goldContainer.leadingAnchor, constant: 15),
            
            goldLabel.topAnchor.constraint(equalTo: goldTitleLabel.bottomAnchor, constant: 5),
            goldLabel.centerXAnchor.constraint(equalTo: goldContainer.centerXAnchor),
            
            skillsLabel.topAnchor.constraint(equalTo: levelContainer.bottomAnchor, constant: 30),
            skillsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            skillsCollectionView.topAnchor.constraint(equalTo: skillsLabel.bottomAnchor, constant: 10),
            skillsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            skillsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            skillsCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            logoutButton.topAnchor.constraint(equalTo: skillsCollectionView.bottomAnchor, constant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Collection view setup
        skillsCollectionView.delegate = self
        skillsCollectionView.dataSource = self
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Loading
    private func loadUserProfile() {
        AuthService.shared.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.user = user
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
                
            case .failure(let error):
                print("Failed to load user profile: \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "프로필 정보를 불러오는데 실패했습니다.")
            }
        }
    }
    
    private func updateUI() {
        guard let user = user else { return }
        
        usernameLabel.text = user.username
        
        // 프로필 이미지 설정
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemBlue
        
        // 레벨 정보 설정
        levelLabel.text = "\(user.level)"
        
        // 다음 레벨까지 필요한 경험치 계산
        let expForNextLevel = user.level * 100
        experienceLabel.text = "경험치: \(user.experience)/\(expForNextLevel)"
        
        // 골드 정보 설정
        goldLabel.text = "\(user.gold)"
        
        // 스킬 컬렉션 뷰 업데이트
        skillsCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            AuthService.shared.signOut { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    // 로그인 화면으로 이동
                    let loginVC = LoginViewController()
                    let navController = UINavigationController(rootViewController: loginVC)
                    navController.modalPresentationStyle = .fullScreen
                    
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = navController
                    }
                    
                case .failure(let error):
                    print("Failed to sign out: \(error.localizedDescription)")
                    self.showAlert(title: "오류", message: "로그아웃에 실패했습니다.")
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.skills.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillCell.identifier, for: indexPath) as? SkillCell else {
            return UICollectionViewCell()
        }
        
        if let skill = user?.skills[indexPath.item] {
            cell.configure(with: skill)
        }
        
        return cell
    }
}

// MARK: - SkillCell
class SkillCell: UICollectionViewCell {
    static let identifier = "SkillCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skillLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(skillLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            skillLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            skillLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            skillLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            skillLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Configuration
    func configure(with skill: String) {
        skillLabel.text = skill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        skillLabel.text = nil
    }
}