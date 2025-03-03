//
//  User.swift
//  MovieMate
//
//  Created by 원대한 on 3/3/25.
//


struct User: Codable {
    let id: String
    let name: String
    let username: String
    let email: String
    let avatar: String
    var bio: String?
}
