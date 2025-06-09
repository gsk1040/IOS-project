//
//  ChatViewModel.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// ViewModels/ChatViewModel.swift
import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    private let alanService = AlanAPIService()
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var clientId: String
    
    init(userId: String) {
        // 사용자 ID를 클라이언트 ID로 사용
        self.clientId = "24271fa8-01a8-4ee8-be61-c9b3a660f410"

        
        // 초기 메시지 추가
        addSystemMessage("안녕하세요! 건강검진 결과에 대해 궁금한 점이 있으시면 편하게 물어보세요.")
    }
    
    func addSystemMessage(_ text: String) {
        let message = ChatMessage(id: UUID().uuidString, text: text, isUser: false, timestamp: Date())
        messages.append(message)
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(id: UUID().uuidString, text: inputText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        let userQuestion = inputText
        inputText = ""
        
        // 메시지 전송 중 상태로 변경
        isLoading = true
        
        Task {
            do {
                let response = try await alanService.sendChat(clientId: clientId, question: userQuestion)
                
                await MainActor.run {
                    self.isLoading = false
                    let botMessage = ChatMessage(id: UUID().uuidString, text: response, isUser: false, timestamp: Date())
                    self.messages.append(botMessage)
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "메시지 전송 중 오류가 발생했습니다: \(error.localizedDescription)"
                    self.addSystemMessage("죄송합니다. 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
                }
            }
        }
    }
    
    func resetChat() {
        Task {
            do {
                let success = try await alanService.resetState(clientId: clientId)
                
                if success {
                    await MainActor.run {
                        self.messages = []
                        self.addSystemMessage("안녕하세요! 건강검진 결과에 대해 궁금한 점이 있으시면 편하게 물어보세요.")
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "대화 초기화 중 오류가 발생했습니다: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id: String
    let text: String
    let isUser: Bool
    let timestamp: Date
}
