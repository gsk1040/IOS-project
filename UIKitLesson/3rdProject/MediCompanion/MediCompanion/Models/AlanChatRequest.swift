//
//  AlanChatRequest.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Models/AlanChat.swift
import Foundation

struct AlanChatRequest: Codable {
    let clientId: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case content
    }
}

struct AlanChatResponse: Codable {
    let action: Action?
    let content: String?
    let answer: String?  // 이전 버전 호환성 유지
    
    struct Action: Codable {
        let name: String?
        let speak: String?
    }
    
    // 실제 응답 내용 추출
    func getResponseText() -> String {
        if let content = content {
            return content
        } else if let answer = answer {
            return answer
        } else if let speak = action?.speak {
            return speak
        } else {
            return "응답을 처리할 수 없습니다."
        }
    }
}

struct ResetStateRequest: Codable {
    let clientId: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
    }
}
