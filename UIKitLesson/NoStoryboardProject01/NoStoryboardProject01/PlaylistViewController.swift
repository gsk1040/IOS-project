//
//  PlaylistViewController.swift
//  NoStoryboardProject01
//
//  Created by 원대한 on 3/17/25.
//


import UIKit
import SwiftUI

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 프로퍼티
    private let tableView = UITableView()
    private let titleLabel = UILabel()
    
    // 노래 데이터
    private let songs: [(id: String, title: String, artist: String, emotion: String)] = [
        ("1", "봄날", "BTS", "행복"),
        ("2", "눈의 꽃", "박효신", "평온"),
        ("3", "FAKE LOVE", "BTS", "슬픔"),
        ("4", "좋은 날", "아이유", "행복"),
        ("5", "에잇", "아이유", "슬픔")
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
        title = "플레이리스트"
    }
    
    private func setupUI() {
        // 타이틀 라벨
        titleLabel.text = "플레이리스트"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        
        // 테이블뷰 설정
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        // 뷰 추가
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    // MARK: - 레이아웃 메서드
    private func layoutUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 타이틀 라벨
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 테이블뷰
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        let song = songs[indexPath.row]
        cell.configure(title: song.title, artist: song.artist, emotion: song.emotion)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


