//
//  Review.swift
//  MovieMate
//
//  Created by 원대한 on 3/3/25.
//


struct Review: Codable {
    let id: String
    let userId: String
    let userName: String
    let userAvatar: String
    let movieId: String
    let rating: Double
    let content: String
    let date: String
    let likeCount: Int
    let commentCount: Int
}
