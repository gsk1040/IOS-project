//
//  YouTubeTranscriptService.swift
//  MediCompanion
//
//  Created by 원대한 on 6/12/25.
//

import Foundation

class YouTubeTranscriptService {
    
    // 이 서비스는 실제 Transcript API를 호출하는 대신,
    // 정상적으로 작동하는 예시(placeholder)로 구현되었습니다.
    // 아래 주석 처리된 실제 API 호출 코드를 참고하여, 추후 실제 사용하시는 API로 교체하셔야 합니다.
    
    func getTranscript(videoId: String) async throws -> String {
        
        // --- 현재 활성화된 코드: 더미 데이터 반환 (테스트 및 개발용) ---
        print("Fetching dummy transcript for video ID: \(videoId)...")
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 딜레이
        
        let dummyTranscript = """
        안녕하세요, 오늘은 콜레스테롤에 대해 알아보겠습니다.
        콜레스테롤은 우리 몸에 꼭 필요한 성분이지만, 너무 많으면 혈관에 쌓여 문제를 일으킬 수 있습니다.
        특히 나쁜 콜레스테롤로 불리는 LDL 콜레스테롤 수치를 관리하는 것이 중요합니다.
        규칙적인 유산소 운동과 식이섬유가 풍부한 채소를 섭취하는 것이 도움이 됩니다.
        """
        
        print("Dummy transcript fetched successfully.")
        return dummyTranscript
        
        
        /*
        // --- [참고] 실제 API를 호출하는 기능 (주석 처리됨) ---
        // 아래 코드를 활성화하려면, 실제 사용하시는 Transcript API의 주소와 인증키가 필요합니다.
         
        // 1. 실제 API 엔드포인트와 API 키를 정의합니다.
        let apiKey = "YOUR_YOUTUBE_TRANSCRIPT_API_KEY" // 실제 API 키로 교체 필요
        let endpoint = "https://api.your-transcript-service.com/v1/transcript" // 실제 API 주소로 교체 필요
        
        guard var components = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "videoId", value: videoId),
            URLQueryItem(name: "lang", value: "ko") // 언어는 한국어로 설정
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        // 2. URL 요청을 생성합니다.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization") // API 키를 헤더에 추가
        request.timeoutInterval = 30
        
        // 3. 네트워크 통신을 통해 데이터를 가져옵니다.
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // 서버에서 오류가 발생한 경우
            throw APIError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        // 4. 받아온 JSON 데이터를 디코딩합니다.
        do {
            let transcriptResponse = try JSONDecoder().decode(YouTubeTranscript.self, from: data)
            
            // 5. 디코딩된 자막(cue)들을 하나의 문자열로 합칩니다.
            let fullTranscript = transcriptResponse.cues
                .map { $0.text }
                .joined(separator: " ")
            
            return fullTranscript
        } catch {
            // JSON 디코딩에 실패한 경우
            throw APIError.responseDecodingFailed
        }
        */
    }
    
    // API 통신 시 발생할 수 있는 오류들을 정의합니다.
    enum APIError: Error, LocalizedError {
        case invalidURL
        case serverError(statusCode: Int)
        case responseDecodingFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "유효하지 않은 URL입니다."
            case .serverError(let statusCode):
                return "서버 오류가 발생했습니다. (코드: \(statusCode))"
            case .responseDecodingFailed:
                return "서버 응답을 처리할 수 없습니다."
            }
        }
    }
}
