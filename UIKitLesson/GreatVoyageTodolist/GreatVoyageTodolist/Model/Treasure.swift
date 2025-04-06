//
//  Treasure.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import FirebaseFirestore

struct Treasure: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var description: String
    var rarity: TreasureRarity = .common
    var imageUrl: String
    var acquiredAt: Date = Date()
    var source: String
    
    enum TreasureRarity: String, Codable {
        case common = "common"
        case uncommon = "uncommon"
        case rare = "rare"
        case epic = "epic"
        case legendary = "legendary"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case description
        case rarity
        case imageUrl = "image_url"
        case acquiredAt = "acquired_at"
        case source
    }
}
