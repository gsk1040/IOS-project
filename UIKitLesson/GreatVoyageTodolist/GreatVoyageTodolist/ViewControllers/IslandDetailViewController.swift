//
//  IslandDetailViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit

class IslandDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let island: Island
    private var challenges: [Challenge] = []
    
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .systemGray5
        progressView.progressTintColor = .systemBlue
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let challengesLabel: UILabel = {
        let label = UILabel()
        label.text = "도전 과제"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addChallengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let challengesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChallengeCell.self, forCellReuseIdentifier: ChallengeCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var challengesTableViewHeightConstraint: NSLayoutConstraint?
    
        
        private let emptyStateView: UIView = {
            let view = UIView()
            view.isHidden = true
            view.backgroundColor = .systemGray6
            view.layer.cornerRadius = 8
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let emptyStateLabel: UILabel = {
            let label = UILabel()
            label.text = "아직 도전 과제가 없습니다.\n새로운 도전 과제를 추가해보세요!"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .gray
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let completeIslandButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("이 섬 정복하기", for: .normal)
            button.backgroundColor = .systemGreen
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.isHidden = true // 기본적으로 숨김 (활성 섬이고 모든 도전과제가 완료된 경우에만 표시)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        // MARK: - Initialization
        init(island: Island) {
            self.island = island
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupActions()
            loadChallenges()
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            view.backgroundColor = .white
            title = "섬 상세"
            
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            contentView.addSubview(headerView)
            headerView.addSubview(titleLabel)
            headerView.addSubview(descriptionLabel)
            headerView.addSubview(statusLabel)
            headerView.addSubview(progressView)
            headerView.addSubview(progressLabel)
            
            contentView.addSubview(challengesLabel)
            contentView.addSubview(addChallengeButton)
            contentView.addSubview(challengesTableView)
            contentView.addSubview(emptyStateView)
            emptyStateView.addSubview(emptyStateLabel)
            contentView.addSubview(completeIslandButton)
            
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
                
                headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                titleLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -10),
                
                statusLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                statusLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                statusLabel.widthAnchor.constraint(equalToConstant: 60),
                statusLabel.heightAnchor.constraint(equalToConstant: 20),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                
                progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
                progressView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                progressView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                progressView.heightAnchor.constraint(equalToConstant: 8),
                
                progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
                progressLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                progressLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
                
                challengesLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
                challengesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                
                addChallengeButton.centerYAnchor.constraint(equalTo: challengesLabel.centerYAnchor),
                addChallengeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                addChallengeButton.widthAnchor.constraint(equalToConstant: 44),
                addChallengeButton.heightAnchor.constraint(equalToConstant: 44),
                
                challengesTableView.topAnchor.constraint(equalTo: challengesLabel.bottomAnchor, constant: 20),
                challengesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                challengesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                emptyStateView.topAnchor.constraint(equalTo: challengesLabel.bottomAnchor, constant: 20),
                emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                emptyStateView.heightAnchor.constraint(equalToConstant: 100),
                
                emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
                emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
                
                completeIslandButton.topAnchor.constraint(equalTo: challengesTableView.bottomAnchor, constant: 30),
                completeIslandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                completeIslandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                completeIslandButton.heightAnchor.constraint(equalToConstant: 50),
                completeIslandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
            ])
            
            // Initial height for table view (will be updated later)
            challengesTableViewHeightConstraint = challengesTableView.heightAnchor.constraint(equalToConstant: 0)
            challengesTableViewHeightConstraint?.isActive = true
            
            // Setup table view
            challengesTableView.delegate = self
            challengesTableView.dataSource = self
            
            // Configure with island data
            titleLabel.text = island.title
            descriptionLabel.text = island.description
            
            let progressValue = Float(island.progress) / 100.0
            progressView.progress = progressValue
            progressLabel.text = "\(Int(island.progress))% 완료"
            
            switch island.status {
            case .locked:
                statusLabel.text = "잠김"
                statusLabel.backgroundColor = .systemGray.withAlphaComponent(0.2)
                statusLabel.textColor = .systemGray
                addChallengeButton.isHidden = true
            case .current:
                statusLabel.text = "현재"
                statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.2)
                statusLabel.textColor = .systemBlue
                addChallengeButton.isHidden = false
            case .completed:
                statusLabel.text = "완료"
                statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
                statusLabel.textColor = .systemGreen
                addChallengeButton.isHidden = true
            }
        }
        
        private func setupActions() {
            addChallengeButton.addTarget(self, action: #selector(addChallengeButtonTapped), for: .touchUpInside)
            completeIslandButton.addTarget(self, action: #selector(completeIslandButtonTapped), for: .touchUpInside)
        }
        
        // MARK: - Data Loading
        private func loadChallenges() {
            ChallengeService.shared.getChallenges(islandId: island.id!) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let challenges):
                    self.challenges = challenges
                    
                    DispatchQueue.main.async {
                        self.challengesTableView.reloadData()
                        self.updateTableViewHeight()
                        self.updateEmptyState()
                        self.updateCompleteButtonVisibility()
                    }
                    
                case .failure(let error):
                    print("Failed to load challenges: \(error.localizedDescription)")
                    self.showAlert(title: "오류", message: "도전 과제를 불러오는데 실패했습니다.")
                }
            }
        }
        
        private func updateTableViewHeight() {
            let height = CGFloat(challenges.count * 120) // 각 셀의 높이 + 여백
            challengesTableViewHeightConstraint?.constant = height
        }
        
        private func updateEmptyState() {
            emptyStateView.isHidden = !challenges.isEmpty
            challengesTableView.isHidden = challenges.isEmpty
        }
        
        private func updateCompleteButtonVisibility() {
            // 활성 섬이고 모든 도전과제가 완료된 경우에만 표시
            let allCompleted = !challenges.isEmpty && challenges.allSatisfy { $0.status == .completed }
            completeIslandButton.isHidden = !(island.status == .current && allCompleted)
        }
        
        // MARK: - Actions
        @objc private func addChallengeButtonTapped() {
            let createChallengeVC = CreateChallengeViewController(islandId: island.id!)
            createChallengeVC.delegate = self
            let navController = UINavigationController(rootViewController: createChallengeVC)
            present(navController, animated: true)
        }
        
        @objc private func completeIslandButtonTapped() {
        // 확인 알림
        let alert = UIAlertController(title: "섬 정복", message: "이 섬을 정복하고 다음 섬으로 이동하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "정복하기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            IslandService.shared.completeIsland(islandId: self.island.id!, voyageId: self.island.voyageId) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let nextIsland):
                    if let nextIsland = nextIsland {
                        // 다음 섬으로 이동
                        let islandDetailVC = IslandDetailViewController(island: nextIsland)
                        self.navigationController?.pushViewController(islandDetailVC, animated: true)
                    } else {
                        // 모든 섬 완료, 대항해 화면으로 돌아가기
                        self.showAlert(title: "축하합니다!", message: "모든 섬을 정복했습니다!") { [weak self] _ in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                case .failure(let error):
                    print("Failed to complete island: \(error.localizedDescription)")
                    self.showAlert(title: "오류", message: "섬 정복에 실패했습니다.")
                }
            }
        })
        
        present(alert, animated: true)
    }
        private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
            present(alert, animated: true)
        }
    }

    // MARK: - UITableView Delegate & DataSource
    extension IslandDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return challenges.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeCell.identifier, for: indexPath) as? ChallengeCell else {
                return UITableViewCell()
            }
            
            let challenge = challenges[indexPath.row]
            cell.configure(with: challenge)
            cell.delegate = self
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }

    // MARK: - ChallengeCellDelegate
    extension IslandDetailViewController: ChallengeCellDelegate {
        func didTapCompleteButton(for challenge: Challenge) {
            ChallengeService.shared.completeChallenge(challengeId: challenge.id!) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let reward):
                    // 보상 표시 및 도전과제 목록 업데이트
                    self.showRewardAlert(reward: reward)
                    self.loadChallenges()
                    
                case .failure(let error):
                    print("Failed to complete challenge: \(error.localizedDescription)")
                    self.showAlert(title: "오류", message: "도전 과제 완료에 실패했습니다.")
                }
            }
        }
        
        private func showRewardAlert(reward: Challenge.Reward) {
            var message = "획득한 보상:\n"
            message += "골드: \(reward.gold)\n"
            message += "경험치: \(reward.experience)"
            
            if !reward.treasures.isEmpty {
                message += "\n특별 보물: \(reward.treasures.joined(separator: ", "))"
            }
            
            if !reward.skills.isEmpty {
                message += "\n새로운 능력: \(reward.skills.joined(separator: ", "))"
            }
            
            let alert = UIAlertController(title: "도전 완료!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }

    // MARK: - CreateChallengeDelegate
    extension IslandDetailViewController: CreateChallengeDelegate {
        func didCreateChallenge(_ challenge: Challenge) {
            challenges.append(challenge)
            challengesTableView.reloadData()
            updateTableViewHeight()
            updateEmptyState()
        }
    }

    // MARK: - ChallengeCell
    protocol ChallengeCellDelegate: AnyObject {
        func didTapCompleteButton(for challenge: Challenge)
    }

    class ChallengeCell: UITableViewCell {
        static let identifier = "ChallengeCell"
        
        // MARK: - Properties
        weak var delegate: ChallengeCellDelegate?
        private var challenge: Challenge?
        
        // MARK: - UI Components
        private let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.shadowOpacity = 0.1
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textColor = .black
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let typeLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            label.textAlignment = .center
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let difficultyView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 2
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let rewardLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .systemOrange
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let completeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("완료", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 15
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let statusLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.textAlignment = .center
            label.isHidden = true
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // MARK: - Initialization
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
            setupActions()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            selectionStyle = .none
            backgroundColor = .clear
            
            contentView.addSubview(containerView)
            containerView.addSubview(titleLabel)
            containerView.addSubview(typeLabel)
            containerView.addSubview(difficultyView)
            containerView.addSubview(descriptionLabel)
            containerView.addSubview(rewardLabel)
            containerView.addSubview(completeButton)
            containerView.addSubview(statusLabel)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                titleLabel.trailingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: -10),
                
                typeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
                typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                typeLabel.widthAnchor.constraint(equalToConstant: 60),
                typeLabel.heightAnchor.constraint(equalToConstant: 20),
                
                difficultyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                difficultyView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                difficultyView.heightAnchor.constraint(equalToConstant: 12),
                difficultyView.widthAnchor.constraint(equalToConstant: 60),
                
                descriptionLabel.topAnchor.constraint(equalTo: difficultyView.bottomAnchor, constant: 5),
                descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                
                rewardLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
                rewardLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                rewardLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
                
                completeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
                completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                completeButton.widthAnchor.constraint(equalToConstant: 70),
                completeButton.heightAnchor.constraint(equalToConstant: 30),
                
                statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
                statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                statusLabel.widthAnchor.constraint(equalToConstant: 70),
                statusLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            // 난이도 표시를 위한 별 추가
            for _ in 0..<5 {
                let starImageView = UIImageView()
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.contentMode = .scaleAspectFit
                starImageView.tintColor = .lightGray
                difficultyView.addArrangedSubview(starImageView)
            }
        }
        
        private func setupActions() {
            completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
        
        // MARK: - Actions
        @objc private func completeButtonTapped() {
            guard let challenge = challenge else { return }
            delegate?.didTapCompleteButton(for: challenge)
        }
        
        // MARK: - Configuration
        func configure(with challenge: Challenge) {
            self.challenge = challenge
            
            titleLabel.text = challenge.title
            descriptionLabel.text = challenge.description
            
            // 난이도 표시
            for (index, starView) in difficultyView.arrangedSubviews.enumerated() {
                if let starImageView = starView as? UIImageView {
                    starImageView.tintColor = index < challenge.difficulty ? .systemYellow : .lightGray
                }
            }
            
            // 유형에 따른 라벨 설정
            switch challenge.type {
            case .sailor:
                typeLabel.text = "선원"
                typeLabel.backgroundColor = .systemBlue.withAlphaComponent(0.2)
                typeLabel.textColor = .systemBlue
            case .pirate:
                typeLabel.text = "해적"
                typeLabel.backgroundColor = .systemPurple.withAlphaComponent(0.2)
                typeLabel.textColor = .systemPurple
            case .captain:
                typeLabel.text = "선장"
                typeLabel.backgroundColor = .systemOrange.withAlphaComponent(0.2)
                typeLabel.textColor = .systemOrange
            case .legend:
                typeLabel.text = "전설"
                typeLabel.backgroundColor = .systemRed.withAlphaComponent(0.2)
                typeLabel.textColor = .systemRed
            }
            
            // 보상 표시
            rewardLabel.text = "보상: 골드 \(challenge.reward.gold), 경험치 \(challenge.reward.experience)"
            
            // 상태에 따른 UI 설정
            switch challenge.status {
            case .pending:
                completeButton.isHidden = false
                statusLabel.isHidden = true
            case .completed:
                completeButton.isHidden = true
                statusLabel.isHidden = false
                statusLabel.text = "완료"
                statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
                statusLabel.textColor = .systemGreen
            case .failed:
                completeButton.isHidden = true
                statusLabel.isHidden = false
                statusLabel.text = "실패"
                statusLabel.backgroundColor = .systemRed.withAlphaComponent(0.2)
                statusLabel.textColor = .systemRed
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
            descriptionLabel.text = nil
            rewardLabel.text = nil
            
            for starView in difficultyView.arrangedSubviews {
                if let starImageView = starView as? UIImageView {
                    starImageView.tintColor = .lightGray
                }
            }
            
            completeButton.isHidden = false
            statusLabel.isHidden = true
        }
    }
