//
//  CreateVoyageViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//

import UIKit

protocol CreateVoyageDelegate: AnyObject {
    func didCreateVoyage(_ voyage: Voyage)
}

class CreateVoyageViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: CreateVoyageDelegate?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 항해 시작하기"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voyageTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "항해 제목을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let voyageDescriptionTextView: UITextView = {
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
        label.text = "항해 설명 (선택사항)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("항해 시작", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 버튼 액션 설정
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "새 항해"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        view.addSubview(titleLabel)
        view.addSubview(voyageTitleTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(voyageDescriptionTextView)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            voyageTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            voyageTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voyageTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            voyageTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: voyageTitleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            voyageDescriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            voyageDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voyageDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            voyageDescriptionTextView.heightAnchor.constraint(equalToConstant: 150),
            
            createButton.topAnchor.constraint(equalTo: voyageDescriptionTextView.bottomAnchor, constant: 30),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func createButtonTapped() {
        guard let title = voyageTitleTextField.text, !title.isEmpty else {
            showAlert(title: "오류", message: "항해 제목을 입력해주세요.")
            return
        }
        
        let description = voyageDescriptionTextView.text ?? ""
        
        VoyageService.shared.createVoyage(title: title, description: description) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let voyage):
                self.delegate?.didCreateVoyage(voyage)
                self.dismiss(animated: true)
                
            case .failure(let error):
                print("Failed to create voyage: \(error.localizedDescription)")
                self.showAlert(title: "오류", message: "항해를 생성하는데 실패했습니다.")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
