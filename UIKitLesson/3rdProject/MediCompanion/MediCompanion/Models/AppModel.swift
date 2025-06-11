//
//  AppModels.swift
//  MediCompanion
//
//  Created by Gemini on 6/12/25.
//

import SwiftUI

// MARK: - Chat Models
struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), text: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

// MARK: - Health Models
enum HealthStatus: String, Codable, CaseIterable {
    case normal = "정상"
    case warning = "주의"
    case danger = "위험"
    
    var color: Color {
        switch self {
        case .normal: return .green
        case .warning: return .orange
        case .danger: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .danger: return "xmark.circle.fill"
        }
    }
}

struct HealthItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let value: String
    let interpretation: String
    let status: HealthStatus
    let referenceRange: String?
    var rawOCRText: String?

    enum CodingKeys: String, CodingKey {
        case id, title, value, interpretation, status, referenceRange
    }
    
    init(id: UUID = UUID(), title: String, value: String, interpretation: String, status: HealthStatus, referenceRange: String? = nil, rawOCRText: String? = nil) {
        self.id = id
        self.title = title
        self.value = value
        self.interpretation = interpretation
        self.status = status
        self.referenceRange = referenceRange
        self.rawOCRText = rawOCRText
    }
    
    func generateYouTubeSearchQuery() -> String {
        let lowercasedTitle = title.lowercased()
        switch lowercasedTitle {
        case let t where t.contains("혈압"): return "고혈압 관리 방법"
        case let t where t.contains("콜레스테롤"): return "콜레스테롤 낮추는 방법"
        case let t where t.contains("혈당"): return "당뇨 관리법"
        default: return "\(title) 건강 관리법"
        }
    }
}

// MARK: - YouTube API Models
struct YouTubeSearchResponse: Codable {
    let items: [YouTubeSearchItem]
}

struct YouTubeSearchItem: Codable, Identifiable {
    let id: VideoId
    let snippet: Snippet
}

struct VideoId: Codable, Hashable {
    let videoId: String
}

struct Snippet: Codable {
    let title: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
    let medium: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
}

// MARK: - YouTube Transcript Models (누락되었던 부분)
struct YouTubeTranscript: Decodable {
    let cues: [TranscriptCue]
}

struct TranscriptCue: Decodable {
    let text: String
}


// MARK: - App's Internal API Models
struct YouTubeSummaryRequest: Codable {
    let videoId: String
    let transcript: String
    let healthItem: HealthItem
    let clientId: String
}

struct YouTubeSummaryResponse: Codable {
    var summary: String
    var videoTitle: String?
}

struct AlanChatResponse: Codable {
    let content: String?
    let answer: String?
    
    func getResponseText() -> String {
        return content ?? answer ?? "응답을 처리할 수 없습니다."
    }
}

struct ResetStateRequest: Codable {
    let clientId: String
}
