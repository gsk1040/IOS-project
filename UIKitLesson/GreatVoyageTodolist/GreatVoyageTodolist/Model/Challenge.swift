//
//  Challenge.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import FirebaseFirestore

struct Challenge: Identifiable, Codable {
    @DocumentID var id: String?
    var islandId: String
    var title: String
    var description: String?
    var difficulty: Int = 1
    var type: ChallengeType = .sailor
    var status: ChallengeStatus = .pending
    var dueDate: Date?
    var reward: Reward
    var createdAt: Date = Date()
    var completedAt: Date?

    
    enum ChallengeType: String, Codable {
        case sailor = "수적"
        case pirate = "해적"
        case captain = "칠무해"
        case legend = "사황"
    }

    
    enum ChallengeStatus: String, Codable {
        case pending = "진행 중"
        case completed = "완료"
        case failed = "실패"
    }

    struct Reward: Codable {
        var gold: Int = 0
        var experience: Int = 0
        var treasures: [String] = []
        var skills: [String] = []
    }

    // Firestore 필드 이름은 영어로 유지 (데이터 호환성)
    enum CodingKeys: String, CodingKey {
        case id
        case islandId = "island_id"
        case title
        case description
        case difficulty
        case type // Firestore에는 "type" 필드에 "수적", "해적" 등의 한글 값이 저장됨
        case status // Firestore에는 "status" 필드에 "진행 중", "완료" 등의 한글 값이 저장됨
        case dueDate = "due_date"
        case reward
        case createdAt = "created_at"
        case completedAt = "completed_at"
    }
}
