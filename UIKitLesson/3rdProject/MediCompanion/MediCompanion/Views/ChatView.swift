//
//  ChatView.swift
//  MediCompanion
//
//  Created by 원대한 on 6/4/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(userId: String = "defaultUser") {
        _viewModel = StateObject(wrappedValue: ChatViewModel(userId: userId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(viewModel: viewModel)
            MessageListView(viewModel: viewModel)
            ChatInputView(viewModel: viewModel)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.stopSpeaking)
    }
}

// MARK: - 하위 뷰 (컴포넌트)

/// 채팅 화면의 상단 헤더 뷰
struct ChatHeaderView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button(action: viewModel.resetChat) { Image(systemName: "arrow.clockwise") }
            Spacer()
            Text("건강 도우미").font(theme.typography.button)
            Spacer()
            
            // 대화 모드 / 검색 모드 전환 토글 버튼
            Button(action: viewModel.toggleChatMode) {
                // 현재 모드에 따라 다른 아이콘을 보여줍니다.
                Image(systemName: viewModel.chatMode == .conversational ? "text.bubble.fill" : "magnifyingglass.circle.fill")
                    .imageScale(.large)
            }
            .padding(.trailing, 8)

            Button(action: { dismiss() }) { Image(systemName: "xmark") }
        }
        .font(.system(size: 20))
        .foregroundColor(theme.colors.primary)
        .padding()
        .background(.bar)
    }
}

/// 메시지 목록을 표시하는 스크롤 뷰
struct MessageListView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    if viewModel.isLoading {
                        LoadingBubble().id("loading")
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    withAnimation { scrollProxy.scrollTo(lastId, anchor: .bottom) }
                }
            }
        }
    }
}

/// 개별 채팅 메시지를 표시하는 말풍선 뷰
struct MessageBubble: View {
    let message: ChatMessage
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .font(.body)
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(theme.colors.primary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                MarkdownView(
                    text: message.text,
                    foregroundColor: colorScheme == .dark ? .white : .black,
                    accentColor: theme.colors.primary
                )
                .padding(.horizontal, 16).padding(.vertical, 10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

/// 로딩 상태를 표시하는 말풍선 뷰
struct LoadingBubble: View {
    var body: some View {
        HStack {
            ProgressView().padding(12).background(.thinMaterial).clipShape(Circle())
            Spacer()
        }.padding(.horizontal)
    }
}

/// 텍스트 입력 및 전송 버튼이 있는 하단 뷰
struct ChatInputView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).font(.caption).foregroundColor(.red).padding(.horizontal).padding(.bottom, 8)
            }
            HStack(spacing: 12) {
                Button(action: { /* TODO: 음성 녹음 */ }) { Image(systemName: "mic.fill") }
                
                TextField("메시지를 입력하세요", text: $viewModel.inputText, onCommit: viewModel.sendMessage)
                    .font(.body).padding(10).background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                Button(action: viewModel.sendMessage) { Image(systemName: "arrow.up.circle.fill") }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
            }
            .font(.system(size: 24))
            .padding()
            .background(.bar)
        }
    }
}
