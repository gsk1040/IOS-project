//
//  User.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Models/User.swift
import Foundation

struct User: Identifiable {
    let id: String
    let email: String
    var remainingScans: Int
    var isPremium: Bool
    
    init(id: String, email: String, remainingScans: Int = 3, isPremium: Bool = false) {
        self.id = id
        self.email = email
        self.remainingScans = remainingScans
        self.isPremium = isPremium
    }
}