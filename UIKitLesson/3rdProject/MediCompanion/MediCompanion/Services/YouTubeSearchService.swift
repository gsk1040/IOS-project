//
//  YouTubeSearchService.swift
//  MediCompanion
//
//  Created by 원대한 on 6/11/25.
//


import Foundation

class YouTubeSearchService {
    private let apiKey = "YOUR_YOUTUBE_API_KEY" // 실제 키로 교체 필요
    
    func searchVideos(query: String, maxResults: Int = 5) async throws -> [YouTubeSearchItem] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(encodedQuery)&type=video&maxResults=\(maxResults)&key=\(apiKey)") else {
            throw SearchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SearchError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw SearchError.apiError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let searchResponse = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
            return searchResponse.items
        } catch {
            print("YouTube 검색 디코딩 오류: \(error)")
            throw SearchError.decodingError
        }
    }
    
    enum SearchError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case apiError(statusCode: Int)
        case decodingError
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "유효하지 않은 URL입니다."
            case .invalidResponse:
                return "유효하지 않은 응답입니다."
            case .apiError(let statusCode):
                return "YouTube API 오류 (코드: \(statusCode))"
            case .decodingError:
                return "응답 데이터를 처리할 수 없습니다."
            }
        }
    }
}