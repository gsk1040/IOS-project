//
//  AlanAPIService.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Services/AlanAPIService.swift
import Foundation
import Network

class AlanAPIService {
    private let baseURL = "https://kdt-api-function.azurewebsites.net/api/v1"
    private let monitor = NWPathMonitor()
    private var isNetworkAvailable = true  // 기본값은 true로 설정
    
    // 간소화된 시스템 프롬프트
    private let systemPrompt = """
    어르신들에게 건강검진 결과를 쉽게 설명해주세요. 혈압, 콜레스테롤, 혈당 등 주요 건강 지표에 대해 
    이해하기 쉬운 비유와 설명을 사용하세요. 수치가 정상인지 비정상인지 판단하고, 
    과도한 걱정이나 불안을 유발하지 않도록 균형 잡힌 정보를 제공하세요.
    """
    
    init() {
        // 네트워크 모니터링 시작
        startNetworkMonitoring()
    }
    
    deinit {
        // 네트워크 모니터링 중단
        monitor.cancel()
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
            print("네트워크 상태: \(self.isNetworkAvailable ? "연결됨" : "연결 안됨")")
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func sendChat(clientId: String, question: String) async throws -> String {
        // 네트워크 연결 확인
        guard isNetworkAvailable else {
            return generateOfflineResponse(for: question)
        }
        
        guard let url = URL(string: "\(baseURL)/question") else {
            throw APIError.invalidURL
        }
        
        // 시스템 프롬프트와 사용자 질문 결합
        let finalContent = "\(systemPrompt)\n\n사용자 질문: \(question)"
        
        // URL 쿼리 파라미터 구성
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // 콘텐츠 인코딩 추가
        let encodedContent = finalContent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "content", value: encodedContent)
        ]
        
        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }
        
        // GET 요청 구성
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        print("API 요청 URL: \(finalURL)")
        print("클라이언트 ID: \(clientId)")
        
        // URL 세션 구성
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("API 응답 코드: \(httpResponse.statusCode)")
            
            // 응답 로깅
            if let responseText = String(data: data, encoding: .utf8) {
                print("원본 응답: \(responseText)")
            }
            
            if httpResponse.statusCode != 200 {
                // URL이 너무 길면 축소된 버전으로 재시도
                if httpResponse.statusCode == 414 { // Request-URI Too Long
                    return try await sendChatWithMinimalPrompt(clientId: clientId, question: question)
                }
                
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                let alanResponse = try decoder.decode(AlanChatResponse.self, from: data)
                
                // 응답 텍스트 추출
                return alanResponse.getResponseText()
            } catch {
                print("JSON 디코딩 오류: \(error)")
                
                // 디코딩 오류 시 수동 파싱 시도
                if let responseText = String(data: data, encoding: .utf8) {
                    // 정규식으로 콘텐츠 추출 시도
                    if let contentMatch = try? NSRegularExpression(pattern: "\"content\":\"(.*?)\"[,}]", options: [.dotMatchesLineSeparators])
                        .firstMatch(in: responseText, options: [], range: NSRange(responseText.startIndex..., in: responseText)),
                       let contentRange = Range(contentMatch.range(at: 1), in: responseText) {
                        
                        let content = String(responseText[contentRange])
                            .replacingOccurrences(of: "\\n", with: "\n")
                            .replacingOccurrences(of: "\\\"", with: "\"")
                        return content
                    }
                    
                    // answer 필드 추출 시도
                    if let answerMatch = try? NSRegularExpression(pattern: "\"answer\":\"(.*?)\"[,}]", options: [.dotMatchesLineSeparators])
                        .firstMatch(in: responseText, options: [], range: NSRange(responseText.startIndex..., in: responseText)),
                       let answerRange = Range(answerMatch.range(at: 1), in: responseText) {
                        
                        let answer = String(responseText[answerRange])
                            .replacingOccurrences(of: "\\n", with: "\n")
                            .replacingOccurrences(of: "\\\"", with: "\"")
                        return answer
                    }
                }
                
                // 모든 시도 실패 시 오프라인 응답 제공
                return generateOfflineResponse(for: question)
            }
        } catch {
            print("API 요청 오류: \(error.localizedDescription)")
            return generateOfflineResponse(for: question)
        }
    }
    
    // URL 길이 제한 오류 시 사용할 최소 프롬프트 버전
    private func sendChatWithMinimalPrompt(clientId: String, question: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/question") else {
            throw APIError.invalidURL
        }
        
        // 매우 간소화된 프롬프트
        let minimalContent = "건강 정보: \(question)"
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "content", value: minimalContent)
        ]
        
        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return generateOfflineResponse(for: question)
        }
        
        do {
            let decoder = JSONDecoder()
            let alanResponse = try decoder.decode(AlanChatResponse.self, from: data)
            return alanResponse.getResponseText()
        } catch {
            return generateOfflineResponse(for: question)
        }
    }
    
    func resetState(clientId: String) async throws -> Bool {
        // 네트워크 연결 확인
        guard isNetworkAvailable else {
            return true  // 오프라인 모드에서는 성공으로 처리
        }
        
        guard let url = URL(string: "\(baseURL)/reset-state") else {
            throw APIError.invalidURL
        }
        
        let resetRequest = ResetStateRequest(clientId: clientId)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(resetRequest)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("Reset 응답 코드: \(httpResponse.statusCode)")
            
            return httpResponse.statusCode == 200 || httpResponse.statusCode == 204
        } catch {
            print("Reset 오류: \(error.localizedDescription)")
            return false  // 오류 발생 시 실패 반환
        }
    }
    
    // 오프라인 모드용 응답 생성
    private func generateOfflineResponse(for question: String) -> String {
        print("오프라인 모드 - 모의 응답 생성")
        
        let lowerQuestion = question.lowercased()
        
        if lowerQuestion.contains("혈압") {
            if lowerQuestion.contains("150/90") || lowerQuestion.contains("150") {
                return "혈압 150/90은 고혈압 단계에 해당합니다. 혈압은 몸속 강물의 세기와 같아서, 너무 세면 혈관에 무리가 갈 수 있어요. 정상 혈압은 120/80 미만입니다. 식이조절, 운동, 스트레스 관리가 도움이 되며, 의사와 상담하시는 것이 좋습니다."
            }
            return "혈압에 대해 말씀드릴게요. 혈압은 몸속 강물의 세기 같아요. 너무 세거나 약하면 문제가 생겨요. 정상 혈압은 120/80 mmHg 미만입니다. 규칙적인 운동, 저염식, 금연, 절주가 혈압 관리에 도움이 됩니다."
        } else if lowerQuestion.contains("콜레스테롤") {
            return "콜레스테롤에 대해 말씀드릴게요. 콜레스테롤은 혈관 기름때 같아요. 많으면 혈관이 좁아질 수 있어요. 총 콜레스테롤은 200 mg/dL 미만이 좋습니다. 좋은 콜레스테롤(HDL)은 높을수록, 나쁜 콜레스테롤(LDL)은 낮을수록 좋습니다. 채소와 과일 섭취, 규칙적인 운동이 도움됩니다."
        } else if lowerQuestion.contains("혈당") {
            return "혈당에 대해 말씀드릴게요. 혈당은 설탕물 농도예요. 너무 진하거나 묽으면 기운이 없거나 문제 생겨요. 공복 혈당은 100 mg/dL 미만이 정상입니다. 식후 2시간 혈당은 140 mg/dL 미만이 좋습니다. 규칙적인 식사와 운동, 체중 관리가 혈당 조절에 중요합니다."
        } else {
            return "건강검진 결과에 대해 더 구체적인 질문이 있으시면 말씀해주세요. 혈압, 콜레스테롤, 혈당 등에 대해 자세히 설명해드릴 수 있습니다. 현재 네트워크 연결이 원활하지 않아 제한된 정보만 제공해드릴 수 있습니다."
        }
    }
    
    // 상세한 오류 타입 정의
    enum APIError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(statusCode: Int)
        case networkError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "유효하지 않은 URL입니다."
            case .invalidResponse:
                return "유효하지 않은 응답입니다."
            case .serverError(let statusCode):
                return "서버 오류 (코드: \(statusCode))가 발생했습니다."
            case .networkError(let message):
                return "네트워크 오류: \(message)"
            }
        }
    }
}
