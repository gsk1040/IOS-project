//
//  YouTubeSummaryViewModel.swift
//  MediCompanion
//
//  Created by 원대한 on 6/12/25.
//

import SwiftUI
import Combine

// 요약 과정의 각 단계를 나타내는 상태
enum SummaryState {
    case idle
    case loading(String) // 로딩 상태 메시지 포함
    case success(YouTubeSummaryResponse)
    case error(String)
}

class YouTubeSummaryViewModel: ObservableObject {
    // [오류 수정] AlanAPIService의 '정의(class...)'가 아닌, '인스턴스(객체)'를 생성하여 사용합니다.
    private let alanService = AlanAPIService()
    
    // TODO: 아래 서비스들은 실제 구현이 필요합니다.
    // private let youtubeSearchService = YouTubeSearchService()
    // private let youtubeTranscriptService = YouTubeTranscriptService()
    
    @Published var state: SummaryState = .idle
    
    // 이 뷰모델에서만 사용할 상태 변수들
    @Published var videoItems: [YouTubeSearchItem] = []
    @Published var selectedVideoId: String?
    @Published var videoTitle: String = ""
    
    private let clientId = "24271fa8-01a8-4ee8-be61-c9b3a660f410"
    
    /// 프로세스 시작점
    func getSummary(for healthItem: HealthItem) {
        state = .loading("관련 영상을 찾는 중...")
        
        // TODO: 실제 유튜브 검색 로직 구현 필요
        // 현재는 더미 데이터로 다음 단계를 시뮬레이션합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchTranscript(videoId: "dummyVideoId", title: "건강 전문가의 콜레스테롤 관리법", healthItem: healthItem)
        }
    }
    
    /// 자막 가져오기
    private func fetchTranscript(videoId: String, title: String, healthItem: HealthItem) {
        state = .loading("자막을 가져오는 중...")
        self.selectedVideoId = videoId
        self.videoTitle = title
        
        // TODO: 실제 자막 추출 로직 구현 필요
        let dummyTranscript = "콜레스테롤은 우리 몸에 꼭 필요하지만 너무 많으면 문제가 됩니다..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.summarizeTranscript(videoId: videoId, transcript: dummyTranscript, healthItem: healthItem)
        }
    }
    
    /// 자막 요약하기
    private func summarizeTranscript(videoId: String, transcript: String, healthItem: HealthItem) {
        state = .loading("AI가 요약하는 중...")
        
        Task {
            do {
                let summaryResponse = try await alanService.summarizeYouTube(
                    clientId: clientId,
                    videoId: videoId,
                    transcript: transcript,
                    healthItem: healthItem
                )
                
                await MainActor.run {
                    self.state = .success(summaryResponse)
                }
            } catch {
                await MainActor.run {
                    self.state = .error("요약 생성 중 오류가 발생했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 다른 비디오 선택 시
    func selectVideo(videoId: String, title: String, healthItem: HealthItem) {
        fetchTranscript(videoId: videoId, title: title, healthItem: healthItem)
    }
}
