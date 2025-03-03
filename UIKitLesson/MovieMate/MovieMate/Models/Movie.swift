//
//  Movie.swift
//  MovieMate
//
//  Created by 원대한 on 3/3/25.
//


struct Movie: Codable {
    let id: String
    let title: String
    let posterUrl: String
    let rating: Double
    let year: String
    let genre: [String]
    let description: String
    let reviewCount: Int
    let likeCount: Int
}