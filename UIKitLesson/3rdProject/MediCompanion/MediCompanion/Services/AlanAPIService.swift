//
//  AlanAPIService.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

import Foundation
import Network

// API 호출 모드를 명확하게 구분하기 위한 열거형
enum ChatMode {
    case conversational // 친근한 대화, 음성 출력에 적합 (출처 X)
    case search         // 정확한 정보와 출처 검색에 적합
}

class AlanAPIService {
    private let baseURL = "https://kdt-api-function.azurewebsites.net/api/v1"
    private let monitor = NWPathMonitor()
    private var isNetworkAvailable = true
    
    // 각 모드에 맞는 두 가지 시스템 프롬프트를 준비합니다.
    private let conversationalSystemPrompt = """
    사용자는 존경받아야할 어르신입니다.어르신께 건강검진 결과(의학용어)같은 어려운 용어는 은유법으로 설명하는것을 최우선으로하세여. 주요 건강 지표[혈압,혈당,병명...]에 대해 수치가 정상인지 비정상인지 판단하고, 과도한 걱정이나 불안을 유발하지 않도록 균형 잡힌 정보를 제공해주세여.
    제약조건:먼저 이전에 했던 사용자의 질문을 초기화합니다. 전체 100자 이하로 짧게 답변해주세요. 사용자 질문에 답변시 가독성을 고려하여 응답하시오. 가독성을 위해 마크다운 문법을 적절히 이용해 문단을 나누어 작성해주세요.불확실한 출처 또는 주소오류,접속오류는 사용하지마세요.
    """
    
    private let searchSystemPrompt = """
∀사용자질문 q∈Q:  
  - 형태소 분석 기반 쿼리 생성  
  - 쿼리 결과 신뢰할 수 있는 출처에서 300≤문장≤500자 내로 요약  
  - 출처(리소스): 키워드 3회 이상 포함  
  - 마크다운 형식으로 출처주소를 각주로 추가  예시:[출처1](https://www.google.com)
  - 불확실한 출처 및 오류가 있는 주소 제외  
  - 한국 병원 및 정부 사이트는 제외  
  - 유튜브, 신뢰할 수 있는 블로그, 뉴스 활용  
    - 검색 결과는 사용자 질문에 대한 답변으로 사용
  - 경어체 사용, 존댓말로 응답
EndNotes: 순서대로 출처 정리    
"""
    
    init() { startNetworkMonitoring() }
    
    private func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }

    func sendChat(clientId: String, question: String, mode: ChatMode) async throws -> String {
        guard isNetworkAvailable else { throw APIError.networkUnavailable }
        
        let selectedPrompt = (mode == .search) ? searchSystemPrompt : conversationalSystemPrompt
        let finalContent = "사용자 질문: \(question)\n\n\(selectedPrompt)"
        
        return try await performChatRequest(clientId: clientId, content: finalContent, question: question)
    }

    private func performChatRequest(clientId: String, content: String, question: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/question") else { throw APIError.invalidURL }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "content", value: content)
        ]
        
        guard let finalURL = components.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        switch httpResponse.statusCode {
        case 200...299:
            let alanResponse = try JSONDecoder().decode(AlanChatResponse.self, from: data)
            return alanResponse.getResponseText()
        case 414:
            return try await performChatRequest(clientId: clientId, content: "사용자 질문: \(question)", question: question)
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    func streamChat(clientId: String, question: String, mode: ChatMode, onReceive: @escaping (String) -> Void, onComplete: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let fullResponse = try await sendChat(clientId: clientId, question: question, mode: mode)
                let chunks = fullResponse.split(separator: " ").map { String($0) }
                for (index, chunk) in chunks.enumerated() {
                    onReceive(chunk + (index == chunks.count - 1 ? "" : " "))
                    try await Task.sleep(nanoseconds: 50_000_000)
                }
                onComplete(.success(()))
            } catch {
                onComplete(.failure(error))
            }
        }
    }

    func summarizeYouTube(clientId: String, videoId: String, transcript: String, healthItem: HealthItem) async throws -> YouTubeSummaryResponse {
        guard isNetworkAvailable else { throw APIError.networkUnavailable }
        guard let url = URL(string: "\(baseURL)/youtube/summarize") else { throw APIError.invalidURL }
        
        let requestPayload = YouTubeSummaryRequest(
            videoId: videoId,
            transcript: transcript,
            healthItem: healthItem,
            clientId: clientId
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestPayload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        return try JSONDecoder().decode(YouTubeSummaryResponse.self, from: data)
    }

    func resetState(clientId: String) async throws -> Bool {
        guard isNetworkAvailable else { return true }
        guard let url = URL(string: "\(baseURL)/reset-state") else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["client_id": clientId])
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        return (200...299).contains(httpResponse.statusCode)
    }

    // [오류 수정 완료] 'enum APIError'를 클래스 내부에, 하지만 다른 함수들 밖에 위치시킵니다.
    enum APIError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(statusCode: Int)
        case responseDecodingFailed
        case networkUnavailable
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "유효하지 않은 URL입니다."
            case .invalidResponse: return "서버로부터 유효한 응답을 받지 못했습니다."
            case .serverError(let statusCode): return "서버 오류가 발생했습니다 (코드: \(statusCode)). 잠시 후 다시 시도해주세요."
            case .responseDecodingFailed: return "서버의 응답을 처리할 수 없습니다."
            case .networkUnavailable: return "네트워크에 연결되어 있지 않습니다. Wi-Fi나 데이터를 확인해주세요."
            }
        }
    }
}
