//
//  EmotionStatsViewController.swift
//  NoStoryboardProject01
//
//  Created by 원대한 on 3/17/25.
//


import UIKit

class EmotionStatsViewController: UIViewController {
    // MARK: - 프로퍼티
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let emotionStackView = UIStackView()
    private let summaryContainerView = UIView()
    private let summaryTitleLabel = UILabel()
    private let summaryTextLabel = UILabel()
    
    // 감정 데이터
    private let emotions: [(emoji: String, label: String, percentage: Int, colors: [UIColor])] = [
        ("😊", "행복", 45, [UIColor(red: 1, green: 0.82, blue: 0.82, alpha: 1), UIColor(red: 1, green: 0.69, blue: 0.69, alpha: 1)]),
        ("😔", "슬픔", 25, [UIColor(red: 0.82, green: 0.89, blue: 1, alpha: 1), UIColor(red: 0.69, green: 0.79, blue: 1, alpha: 1)]),
        ("😠", "화남", 15, [UIColor(red: 1, green: 0.88, blue: 0.82, alpha: 1), UIColor(red: 1, green: 0.80, blue: 0.69, alpha: 1)]),
        ("😌", "평온", 15, [UIColor(red: 0.82, green: 1, blue: 0.89, alpha: 1), UIColor(red: 0.69, green: 1, blue: 0.83, alpha: 1)])
    ]
    
    // MARK: - 라이프사이클 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        layoutUI()
    }
    
    // MARK: - 셋업 메서드
    private func setup() {
        view.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 250/255, alpha: 0.95)
        title = "감정 통계"
    }
    
    private func setupUI() {
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 타이틀 라벨
        titleLabel.text = "이번 달 감정 통계"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.black
        
        // 감정 스택뷰
        emotionStackView.axis = .vertical
        emotionStackView.spacing = 12
        emotionStackView.distribution = .fillEqually
        
        // 각 감정에 대한 카드 생성
        for emotion in emotions {
            let card = createEmotionStatCard(emoji: emotion.emoji, label: emotion.label, percentage: emotion.percentage, colors: emotion.colors)
            emotionStackView.addArrangedSubview(card)
        }
        
        // 요약 컨테이너
        summaryContainerView.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        summaryContainerView.layer.cornerRadius = 16
        
        // 요약 타이틀
        summaryTitleLabel.text = "월간 감정 요약"
        summaryTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        summaryTitleLabel.textColor = UIColor.black
        
        // 요약 텍스트
        summaryTextLabel.text = "이번 달은 전반적으로 긍정적인 감정이 우세했네요! 행복한 순간이 45%로 가장 많았고, 슬픔과 화남의 감정도 잘 조절하면서 보내셨어요."
        summaryTextLabel.font = UIFont.systemFont(ofSize: 14)
        summaryTextLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        summaryTextLabel.numberOfLines = 0
        
        // 각 뷰 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(emotionStackView)
        contentView.addSubview(summaryContainerView)
        summaryContainerView.addSubview(summaryTitleLabel)
        summaryContainerView.addSubview(summaryTextLabel)
    }
    
    private func createEmotionStatCard(emoji: String, label: String, percentage: Int, colors: [UIColor]) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        
        // 그래디언트 배경 생성
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 80)
        cardView.layer.insertSublayer(gradientLayer, at: 0)
        
        // 내용 뷰
        let contentView = UIView()
        contentView.backgroundColor = .clear
        
        // 왼쪽 컨텐츠 (이모지 + 라벨)
        let leftContentView = UIView()
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 24)
        
        let textLabel = UILabel()
        textLabel.text = label
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        
        // 퍼센트 라벨
        let percentLabel = UILabel()
        percentLabel.text = "\(percentage)%"
        percentLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        percentLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        
        // 뷰 계층 구조 설정
        cardView.addSubview(contentView)
        contentView.addSubview(leftContentView)
        leftContentView.addSubview(emojiLabel)
        leftContentView.addSubview(textLabel)
        contentView.addSubview(percentLabel)
        
        // 제약조건 설정
        contentView.translatesAutoresizingMaskIntoConstraints = false
        leftContentView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 내용 뷰
            contentView.topAnchor.constraint(equalTo: cardView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            // 왼쪽 컨텐츠
            leftContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 이모지
            emojiLabel.leadingAnchor.constraint(equalTo: leftContentView.leadingAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: leftContentView.centerYAnchor),
            
            // 텍스트 라벨
            textLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            textLabel.centerYAnchor.constraint(equalTo: leftContentView.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: leftContentView.trailingAnchor),
            
            // 퍼센트 라벨
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // 카드 뷰 높이 설정
        cardView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return cardView
    }
    
    // MARK: - 레이아웃 메서드
    private func layoutUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionStackView.translatesAutoresizingMaskIntoConstraints = false
        summaryContainerView.translatesAutoresizingMaskIntoConstraints = false
        summaryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // 타이틀 라벨
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 감정 스택뷰
            emotionStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            emotionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 요약 컨테이너
            summaryContainerView.topAnchor.constraint(equalTo: emotionStackView.bottomAnchor, constant: 32),
            summaryContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            summaryContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            summaryContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            // 요약 타이틀
            summaryTitleLabel.topAnchor.constraint(equalTo: summaryContainerView.topAnchor, constant: 20),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 20),
            summaryTitleLabel.trailingAnchor.constraint(equalTo: summaryContainerView.trailingAnchor, constant: -20),
            
            // 요약 텍스트
            summaryTextLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 12),
            summaryTextLabel.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 20),
            summaryTextLabel.trailingAnchor.constraint(equalTo: summaryContainerView.trailingAnchor, constant: -20),
            summaryTextLabel.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor, constant: -20)
        ])
    }
}