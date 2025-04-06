//
//  Island.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import Foundation
import FirebaseFirestore

struct Island: Identifiable, Codable {
    @DocumentID var id: String?
    var voyageId: String
    var title: String
    var description: String
    var order: Int = 0
    var status: IslandStatus = .locked
    var progress: Double = 0.0
    var coordinates: [String: Double] = ["x": 0, "y": 0]
    
    enum IslandStatus: String, Codable {
        case locked = "locked"
        case current = "current"
        case completed = "completed"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case voyageId = "voyage_id"
        case title
        case description
        case order
        case status
        case progress
        case coordinates
    }
}
