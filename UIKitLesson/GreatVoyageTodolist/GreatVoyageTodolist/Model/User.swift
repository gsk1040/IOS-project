//
//  User.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var username: String
    var profileImageUrl: String?
    var gold: Int = 0
    var level: Int = 1
    var experience: Int = 0
    var skills: [String] = []
    var createdAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case profileImageUrl = "profile_image_url"
        case gold
        case level
        case experience = "exp"
        case skills
        case createdAt = "created_at"
    }
}
