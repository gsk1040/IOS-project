//
//  TreasuresViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit
import Kingfisher

class TreasuresViewController: UIViewController {
    
    // MARK: - Properties
    private var treasures: [Treasure] = []
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TreasureCell.self, forCellWithReuseIdentifier: TreasureCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 획득한 보물이 없습니다.\n도전 과제를 완료하여 보물을 모아보세요!"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTreasures()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "보물"
        
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
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Data Loading
    private func loadTreasures() {
        TreasureService.shared.getTreasures { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let treasures):
                self.treasures = treasures
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.updateEmptyState()
                }
                
            case .failure(let error):
                print("Failed to load treasures: \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "보물 정보를 불러오는데 실패했습니다.")
            }
        }
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !treasures.isEmpty
        collectionView.isHidden = treasures.isEmpty
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension TreasuresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treasures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TreasureCell.identifier, for: indexPath) as? TreasureCell else {
            return UICollectionViewCell()
        }
        
        let treasure = treasures[indexPath.item]
        cell.configure(with: treasure)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 2 // 60 = 좌우 여백(40) + 아이템 간격(20)
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let treasure = treasures[indexPath.item]
        let treasureDetailVC = TreasureDetailViewController(treasure: treasure)
        navigationController?.pushViewController(treasureDetailVC, animated: true)
    }
}

// MARK: - TreasureCell
class TreasureCell: UICollectionViewCell {
    static let identifier = "TreasureCell"
    
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
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
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(rarityLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            rarityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            rarityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            rarityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            rarityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configuration
    func configure(with treasure: Treasure) {
        nameLabel.text = treasure.name
        
        // 실제 앱에서는 Kingfisher 라이브러리를 사용하여 이미지 로드
        // imageView.kf.setImage(with: URL(string: treasure.imageUrl))
        
        // 여기서는 테스트용 이미지 설정
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = rarityColor(treasure.rarity)
        
        // 희귀도에 따른 라벨 설정
        rarityLabel.text = rarityText(treasure.rarity)
        rarityLabel.backgroundColor = rarityColor(treasure.rarity).withAlphaComponent(0.2)
        rarityLabel.textColor = rarityColor(treasure.rarity)
    }
    
    private func rarityText(_ rarity: Treasure.TreasureRarity) -> String {
        switch rarity {
        case .common: return "일반"
        case .uncommon: return "희귀"
        case .rare: return "레어"
        case .epic: return "에픽"
        case .legendary: return "전설"
        }
    }
    
    private func rarityColor(_ rarity: Treasure.TreasureRarity) -> UIColor {
        switch rarity {
        case .common: return .systemGray
        case .uncommon: return .systemGreen
        case .rare: return .systemBlue
        case .epic: return .systemPurple
        case .legendary: return .systemOrange
        case .epic: return .systemPurple
               case .legendary: return .systemOrange
               }
           }
           
           override func prepareForReuse() {
               super.prepareForReuse()
               imageView.image = nil
               nameLabel.text = nil
               rarityLabel.text = nil
           }
        }
