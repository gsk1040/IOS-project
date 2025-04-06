//
//  TreasureDetailViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit
import Kingfisher

class TreasureDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let treasure: Treasure
    
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let acquisitionDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(treasure: Treasure) {
        self.treasure = treasure
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithTreasure()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "보물 상세"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rarityLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(acquisitionDateLabel)
        contentView.addSubview(sourceLabel)
        
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
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            rarityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            rarityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rarityLabel.widthAnchor.constraint(equalToConstant: 100),
            rarityLabel.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionLabel.topAnchor.constraint(equalTo: rarityLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            acquisitionDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            acquisitionDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acquisitionDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            sourceLabel.topAnchor.constraint(equalTo: acquisitionDateLabel.bottomAnchor, constant: 5),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Configuration
    private func configureWithTreasure() {
        nameLabel.text = treasure.name
        descriptionLabel.text = treasure.description
        
        // 실제 앱에서는 Kingfisher 라이브러리를 사용하여 이미지 로드
        // imageView.kf.setImage(with: URL(string: treasure.imageUrl))
        
        // 여기서는 테스트용 이미지 설정
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = rarityColor(treasure.rarity)
        
        // 희귀도에 따른 라벨 설정
        rarityLabel.text = rarityText(treasure.rarity)
        rarityLabel.backgroundColor = rarityColor(treasure.rarity).withAlphaComponent(0.2)
        rarityLabel.textColor = rarityColor(treasure.rarity)
        
        // 획득 날짜 및 출처 표시
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        acquisitionDateLabel.text = "획득 시간: \(dateFormatter.string(from: treasure.acquiredAt))"
        sourceLabel.text = "출처: \(treasure.source)"
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
        }
    }
}