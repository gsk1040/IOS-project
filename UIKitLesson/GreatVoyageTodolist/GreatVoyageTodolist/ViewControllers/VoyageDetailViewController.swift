//
//  VoyageDetailViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit

class VoyageDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let voyage: Voyage
    private var islands: [Island] = []
    
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
    
    private let addIslandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 섬 추가", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let islandsLabel: UILabel = {
        let label = UILabel()
        label.text = "항해 경로"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let islandsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IslandCell.self, forCellReuseIdentifier: IslandCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var islandsTableViewHeightConstraint: NSLayoutConstraint?
    
    private let emptyIslandsView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyIslandsLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 섬이 없습니다.\n새로운 섬을 추가해보세요!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(voyage: Voyage) {
        self.voyage = voyage
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
        loadIslands()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "항해 상세"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(descriptionLabel)
        headerView.addSubview(progressView)
        headerView.addSubview(progressLabel)
        
        contentView.addSubview(islandsLabel)
        contentView.addSubview(islandsTableView)
        contentView.addSubview(emptyIslandsView)
        emptyIslandsView.addSubview(emptyIslandsLabel)
        contentView.addSubview(addIslandButton)
        
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
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            
            progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            progressView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            progressLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            progressLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            islandsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            islandsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            islandsTableView.topAnchor.constraint(equalTo: islandsLabel.bottomAnchor, constant: 20),
            islandsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            islandsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emptyIslandsView.topAnchor.constraint(equalTo: islandsLabel.bottomAnchor, constant: 20),
            emptyIslandsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyIslandsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyIslandsView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyIslandsLabel.centerXAnchor.constraint(equalTo: emptyIslandsView.centerXAnchor),
            emptyIslandsLabel.centerYAnchor.constraint(equalTo: emptyIslandsView.centerYAnchor),
            
            addIslandButton.topAnchor.constraint(equalTo: islandsTableView.bottomAnchor, constant: 20),
            addIslandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addIslandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addIslandButton.heightAnchor.constraint(equalToConstant: 50),
            addIslandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Initial height for table view (will be updated later)
        islandsTableViewHeightConstraint = islandsTableView.heightAnchor.constraint(equalToConstant: 0)
        islandsTableViewHeightConstraint?.isActive = true
        
        // Setup table view
        islandsTableView.delegate = self
        islandsTableView.dataSource = self
        
        // Configure with voyage data
        titleLabel.text = voyage.title
        descriptionLabel.text = voyage.description
        
        let progressValue = Float(voyage.progress) / 100.0
        progressView.progress = progressValue
        progressLabel.text = "\(Int(voyage.progress))% 완료"
    }
    
    private func setupActions() {
        addIslandButton.addTarget(self, action: #selector(addIslandButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Loading
    private func loadIslands() {
        IslandService.shared.getIslands(voyageId: voyage.id!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let islands):
                self.islands = islands
                
                DispatchQueue.main.async {
                    self.islandsTableView.reloadData()
                    self.updateTableViewHeight()
                    self.updateEmptyState()
                }
                
            case .failure(let error):
                print("Failed to load islands: \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "섬 정보를 불러오는데 실패했습니다.")
            }
        }
    }
    
    private func updateTableViewHeight() {
        let height = CGFloat(islands.count * 130) // 각 셀의 높이 + 여백
        islandsTableViewHeightConstraint?.constant = height
    }
    
    private func updateEmptyState() {
        emptyIslandsView.isHidden = !islands.isEmpty
        islandsTableView.isHidden = islands.isEmpty
    }
    
    // MARK: - Actions
    @objc private func addIslandButtonTapped() {
        let alertController = UIAlertController(title: "새로운 섬 추가", message: "항해 경로에 새로운 섬을 추가합니다.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "섬 이름"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "섬 설명"
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let self = self,
                  let titleTextField = alertController.textFields?[0],
                  let title = titleTextField.text, !title.isEmpty,
                  let descriptionTextField = alertController.textFields?[1],
                  let description = descriptionTextField.text else {
                return
            }
            
            // 랜덤 좌표 생성 (실제로는 지도에서 선택하게 할 수 있음)
            let coordinates: [String: Double] = [
                "x": Double.random(in: 0...100),
                "y": Double.random(in: 0...100)
            ]
            
            IslandService.shared.createIsland(voyageId: self.voyage.id!, title: title, description: description, coordinates: coordinates) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let island):
                    self.islands.append(island)
                    
                    DispatchQueue.main.async {
                        self.islandsTableView.reloadData()
                        self.updateTableViewHeight()
                        self.updateEmptyState()
                    }
                    
                case .failure(let error):
                    print("Failed to create island: \(error.localizedDescription)")
                    self.showAlert(title: "오류", message: "섬을 생성하는데 실패했습니다.")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension VoyageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return islands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IslandCell.identifier, for: indexPath) as? IslandCell else {
            return UITableViewCell()
        }
        
        let island = islands[indexPath.row]
        cell.configure(with: island)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let island = islands[indexPath.row]
        let islandDetailVC = IslandDetailViewController(island: island)
        navigationController?.pushViewController(islandDetailVC, animated: true)
    }
}

// MARK: - IslandCell
class IslandCell: UITableViewCell {
    static let identifier = "IslandCell"
    
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(progressView)
        containerView.addSubview(progressLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -10),
            
            statusLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            statusLabel.widthAnchor.constraint(equalToConstant: 60),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            progressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Configuration
    func configure(with island: Island) {
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
        case .current:
            statusLabel.text = "현재"
            statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            statusLabel.textColor = .systemBlue
        case .completed:
            statusLabel.text = "완료"
            statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGreen
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        progressView.progress = 0
        progressLabel.text = nil
        statusLabel.text = nil
    }
}