//
//  ChatViewModel.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

import SwiftUI
import AVFoundation

class ChatViewModel: ObservableObject {
    private let alanService = AlanAPIService()
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // [추가] 현재 채팅 모드를 관리하는 상태 변수 (기본값: 대화 모드)
    @Published var chatMode: ChatMode = .conversational
    
    // [수정] 음성 출력 활성화 여부는 이제 chatMode에 따라 자동으로 결정됩니다.
    var isSpeechEnabled: Bool {
        return chatMode == .conversational
    }
    @Published var speechRate: Float = 0.55 // 사용자님이 설정하신 속도
    
    private var clientId: String
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init(userId: String) {
        self.clientId = "24271fa8-01a8-4ee8-be61-c9b3a660f410"
    }
    
    func onAppear() {
        if messages.isEmpty {
            addSystemMessage("안녕하세요! 건강검진 결과에 대해 궁금한 점이 있으시면 편하게 물어보세요.")
        }
    }

    private func addSystemMessage(_ text: String) {
        messages.append(ChatMessage(id: UUID(), text: text, isUser: false, timestamp: Date()))
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        let userQuestion = inputText
        inputText = ""
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                // [수정] 현재 설정된 모드(chatMode)를 API 호출 시 함께 전달합니다.
                let response = try await alanService.sendChat(clientId: clientId, question: userQuestion, mode: self.chatMode)
                
                await MainActor.run {
                    self.isLoading = false
                    let botMessage = ChatMessage(id: UUID(), text: response, isUser: false, timestamp: Date())
                    self.messages.append(botMessage)
                    
                    if self.isSpeechEnabled {
                        self.speakText(response)
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "오류: \(error.localizedDescription)"
                    self.addSystemMessage("죄송합니다. 답변을 받아오는 데 실패했습니다.")
                }
            }
        }
    }
    
    // [추가] 채팅 모드를 전환하는 함수
    func toggleChatMode() {
        if chatMode == .conversational {
            chatMode = .search
            stopSpeaking() // 검색 모드로 바꾸면 음성 중지
        } else {
            chatMode = .conversational
        }
    }
    
    func speakText(_ text: String) {
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = self.speechRate
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    func resetChat() {
        stopSpeaking()
        messages = []
        onAppear()
    }
}
