//
//  CreateChallengeDelegate.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//

import UIKit

protocol CreateChallengeDelegate: AnyObject {
    func didCreateChallenge(_ challenge: Challenge)
}

class CreateChallengeViewController: UIViewController {
    
    // MARK: - Properties
    private let islandId: String
    weak var delegate: CreateChallengeDelegate?
    
    private var selectedDifficulty: Int = 3
    private var selectedType: Challenge.ChallengeType = .sailor
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 도전 과제"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let challengeTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "도전 과제 제목"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let challengeDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "도전 과제 설명 (선택사항)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "난이도"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyControl: UISegmentedControl = {
        let items = ["1", "2", "3", "4", "5"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 2 // 기본값 3
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "유형"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeControl: UISegmentedControl = {
        let items = ["선원", "해적", "선장", "전설"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0 // 기본값 선원
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = "마감일"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
    private let rewardPreviewLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 보상"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rewardPreviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let goldRewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expRewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let treasureRewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("도전 과제 생성", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(islandId: String) {
        self.islandId = islandId
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
        updateRewardPreview()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "새 도전 과제"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(challengeTitleTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(challengeDescriptionTextView)
        contentView.addSubview(difficultyLabel)
        contentView.addSubview(difficultyControl)
        contentView.addSubview(typeLabel)
        contentView.addSubview(typeControl)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(dueDateSwitch)
        contentView.addSubview(dueDatePicker)
        contentView.addSubview(rewardPreviewLabel)
        contentView.addSubview(rewardPreviewView)
        rewardPreviewView.addSubview(goldRewardLabel)
        rewardPreviewView.addSubview(expRewardLabel)
        rewardPreviewView.addSubview(treasureRewardLabel)
        contentView.addSubview(createButton)
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            challengeTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            challengeTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            challengeTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            challengeTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: challengeTitleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            challengeDescriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            challengeDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            challengeDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            challengeDescriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            difficultyLabel.topAnchor.constraint(equalTo: challengeDescriptionTextView.bottomAnchor, constant: 20),
            difficultyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            difficultyControl.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 10),
            difficultyControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            difficultyControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            typeLabel.topAnchor.constraint(equalTo: difficultyControl.bottomAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            typeControl.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            typeControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dueDateLabel.topAnchor.constraint(equalTo: typeControl.bottomAnchor, constant: 20),
            dueDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dueDateSwitch.centerYAnchor.constraint(equalTo: dueDateLabel.centerYAnchor),
            dueDateSwitch.leadingAnchor.constraint(equalTo: dueDateLabel.trailingAnchor, constant: 20),
            
            dueDatePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 10),
            dueDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dueDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            rewardPreviewLabel.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 20),
            rewardPreviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            rewardPreviewView.topAnchor.constraint(equalTo: rewardPreviewLabel.bottomAnchor, constant: 10),
            rewardPreviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rewardPreviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            goldRewardLabel.topAnchor.constraint(equalTo: rewardPreviewView.topAnchor, constant: 15),
            goldRewardLabel.leadingAnchor.constraint(equalTo: rewardPreviewView.leadingAnchor, constant: 15),
            goldRewardLabel.trailingAnchor.constraint(equalTo: rewardPreviewView.trailingAnchor, constant: -15),
            
            expRewardLabel.topAnchor.constraint(equalTo: goldRewardLabel.bottomAnchor, constant: 5),
            expRewardLabel.leadingAnchor.constraint(equalTo: rewardPreviewView.leadingAnchor, constant: 15),
            expRewardLabel.trailingAnchor.constraint(equalTo: rewardPreviewView.trailingAnchor, constant: -15),
            
            treasureRewardLabel.topAnchor.constraint(equalTo: expRewardLabel.bottomAnchor, constant: 5),
            treasureRewardLabel.leadingAnchor.constraint(equalTo: rewardPreviewView.leadingAnchor, constant: 15),
            treasureRewardLabel.trailingAnchor.constraint(equalTo: rewardPreviewView.trailingAnchor, constant: -15),
            treasureRewardLabel.bottomAnchor.constraint(equalTo: rewardPreviewView.bottomAnchor, constant: -15),
            
            createButton.topAnchor.constraint(equalTo: rewardPreviewView.bottomAnchor, constant: 30),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        difficultyControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        typeControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
        dueDateSwitch.addTarget(self, action: #selector(dueDateSwitchChanged), for: .valueChanged)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func difficultyChanged() {
        selectedDifficulty = difficultyControl.selectedSegmentIndex + 1
        updateRewardPreview()
    }
    
    @objc private func typeChanged() {
        switch typeControl.selectedSegmentIndex {
        case 0: selectedType = .sailor
        case 1: selectedType = .pirate
        case 2: selectedType = .captain
        case 3: selectedType = .legend
        default: selectedType = .sailor
        }
        updateRewardPreview()
    }
    
    @objc private func dueDateSwitchChanged() {
        dueDatePicker.isHidden = !dueDateSwitch.isOn
    }
    
    @objc private func createButtonTapped() {
        guard let title = challengeTitleTextField.text, !title.isEmpty else {
            showAlert(title: "오류", message: "도전 과제 제목을 입력해주세요.")
            return
        }
        
        let description = challengeDescriptionTextView.text
        
        // 마감일 설정
        let dueDate: Date? = dueDateSwitch.isOn ? dueDatePicker.date : nil
        
        ChallengeService.shared.createChallenge(
            islandId: islandId,
            title: title,
            description: description,
            difficulty: selectedDifficulty,
            type: selectedType,
            dueDate: dueDate
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let challenge):
                self.delegate?.didCreateChallenge(challenge)
                self.dismiss(animated: true)
                
            case .failure(let error):
                print("Failed to create challenge: \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "도전 과제를 생성하는데 실패했습니다.")
            }
        }
    }
    
    private func updateRewardPreview() {
        // 난이도와 유형에 따른 보상 계산 (ChallengeService의 로직과 유사)
        var baseGold = 0
        var baseExp = 0
        
        switch selectedType {
        case .sailor:
            baseGold = 50
            baseExp = 5
        case .pirate:
            baseGold = 100
            baseExp = 10
        case .captain:
            baseGold = 300
            baseExp = 30
        case .legend:
            baseGold = 1000
            baseExp = 100
        }
        
        // 난이도에 따른 보상 배율
        let multiplier = 1.0 + (Double(selectedDifficulty) * 0.2)
        
        let gold = Int(Double(baseGold) * multiplier)
        let exp = Int(Double(baseExp) * multiplier)
        
        goldRewardLabel.text = "골드: \(gold)"
        expRewardLabel.text = "경험치: \(exp)"
        
        // 보물 확률 표시
        let treasureChance = selectedDifficulty * 5
        let skillChance = selectedDifficulty * 2
        
        var treasureText = "특별 보상: "
        
        if selectedDifficulty >= 4 {
            treasureText += "보물 (\(treasureChance)% 확률)"
            
            if selectedDifficulty == 5 {
                treasureText += ", 능력 (\(skillChance)% 확률)"
            }
        } else {
            treasureText += "없음"
        }
        
        treasureRewardLabel.text = treasureText
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
