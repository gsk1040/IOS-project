//
//  Voyage.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import FirebaseFirestore

struct Voyage: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var title: String
    var description: String
    var status: VoyageStatus = .ongoing
    var progress: Double = 0.0
    var createdAt: Date = Date()
    var completedAt: Date?
    
    enum VoyageStatus: String, Codable {
        case ongoing = "ongoing"
        case completed = "completed"
        case abandoned = "abandoned"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case status
        case progress
        case createdAt = "created_at"
        case completedAt = "completed_at"
    }
}
