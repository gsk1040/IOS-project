//
//  HomeViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var voyages: [Voyage] = []
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VoyageCell.self, forCellReuseIdentifier: VoyageCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let createVoyageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 항해 시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 항해를 시작하지 않았습니다.\n새로운 항해를 시작해보세요!"
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadVoyages()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "위대한 항해"
        
        // Empty state view setup
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -40),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
        ])
        
        // Main view setup
        view.addSubview(tableView)
        view.addSubview(createVoyageButton)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createVoyageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createVoyageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createVoyageButton.widthAnchor.constraint(equalToConstant: 200),
            createVoyageButton.heightAnchor.constraint(equalToConstant: 50),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: createVoyageButton.topAnchor)
        ])
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupActions() {
        createVoyageButton.addTarget(self, action: #selector(createVoyageButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Loading
    private func loadVoyages() {
        print("HomeVC: Attempting to load voyages...") // 로딩 시도 로그
        VoyageService.shared.getVoyages { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let voyages):
                print("HomeVC: Successfully loaded \(voyages.count) voyages.") // 성공 및 개수 로그
                self.voyages = voyages
                
                DispatchQueue.main.async {
                    print("HomeVC: Reloading table view on main thread.") // UI 업데이트 로그
                    self.tableView.reloadData()
                    self.updateEmptyState()
                }
                
            case .failure(let error):
                // 실패 시 오류 로그 강화
                print("HomeVC Error: Failed to load voyages - \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "항해 정보를 불러오는데 실패했습니다: \(error.localizedDescription)") // 오류 메시지에 상세 내용 포함
            }
        }
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !voyages.isEmpty
        tableView.isHidden = voyages.isEmpty
    }
    
    // MARK: - Actions
    @objc private func createVoyageButtonTapped() {
        let createVoyageVC = CreateVoyageViewController()
        createVoyageVC.delegate = self
        let navController = UINavigationController(rootViewController: createVoyageVC)
        present(navController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voyages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VoyageCell.identifier, for: indexPath) as? VoyageCell else {
            return UITableViewCell()
        }
        
        let voyage = voyages[indexPath.row]
        cell.configure(with: voyage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let voyage = voyages[indexPath.row]
        let voyageDetailVC = VoyageDetailViewController(voyage: voyage)
        navigationController?.pushViewController(voyageDetailVC, animated: true)
    }
}

// MARK: - CreateVoyageDelegate
extension HomeViewController: CreateVoyageDelegate {
    func didCreateVoyage(_ voyage: Voyage) {
        voyages.insert(voyage, at: 0)
        tableView.reloadData()
        updateEmptyState()
    }
}

// MARK: - VoyageCell
class VoyageCell: UITableViewCell {
    static let identifier = "VoyageCell"
    
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
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
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
    func configure(with voyage: Voyage) {
        titleLabel.text = voyage.title
        descriptionLabel.text = voyage.description
        
        let progressValue = Float(voyage.progress) / 100.0
        progressView.progress = progressValue
        progressLabel.text = "\(Int(voyage.progress))% 완료"
        
        switch voyage.status {
        case .ongoing:
            statusLabel.text = "진행중"
            statusLabel.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            statusLabel.textColor = .systemBlue
        case .completed:
            statusLabel.text = "완료"
            statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGreen
        case .abandoned:
            statusLabel.text = "중단"
            statusLabel.backgroundColor = .systemRed.withAlphaComponent(0.2)
            statusLabel.textColor = .systemRed
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

#Preview {
    HomeViewController()
}
