//
//  ChatView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//


// Views/ChatView.swift
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        // 뷰모델은 앱에서 생성하여 전달받는 것이 좋지만, 예시를 위해 이렇게 구현
        let userId = UUID().uuidString // 실제로는 인증된 사용자 ID 사용
        _viewModel = StateObject(wrappedValue: ChatViewModel(userId: userId))
    }
    
    var body: some View {
        VStack {
            // 상단 헤더
            HStack {
                Button(action: {
                    viewModel.resetChat()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 22))
                        .foregroundColor(theme.colors.primary)
                }
                
                Spacer()
                
                Text("건강 도우미")
                    .font(AppTheme.Typography.Button().font)
                    .foregroundStyle(theme.colors.textLight)
                
                Spacer()
                
                Button(action: {
                    // 뒤로 가기 기능 또는 설정
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 22))
                        .foregroundColor(theme.colors.primary)
                }
            }
            .padding()
            
            // 메시지 목록
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        // 로딩 인디케이터
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                            }
                            .padding(.horizontal)
                            .id("loading")
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        if let lastMessage = viewModel.messages.last {
                            scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isLoading) { isLoading in
                    if isLoading {
                        withAnimation {
                            scrollProxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            // 에러 메시지
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(AppTheme.Typography.Caption().font)
                    .foregroundColor(theme.colors.danger)
                    .padding(.horizontal)
            }
            
            // 메시지 입력 영역
            HStack {
                TextField("메시지를 입력하세요", text: $viewModel.inputText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.leading)
                
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(theme.colors.primary)
                }
                .padding()
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            }
            .padding(.bottom, 8)
        }
        .background(colorScheme == .dark ? theme.colors.backgroundDark : theme.colors.backgroundLight)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(theme.colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .cornerRadius(18, corners: [.topLeft, .topRight, .bottomLeft])
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(colorScheme == .dark ? theme.colors.textDark : theme.colors.textLight)
                    .cornerRadius(18)
                    .cornerRadius(18, corners: [.topRight, .bottomRight, .bottomLeft])
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
