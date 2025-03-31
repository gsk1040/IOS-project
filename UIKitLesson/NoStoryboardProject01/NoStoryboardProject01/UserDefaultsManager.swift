//
//  UserDefaultsManager.swift
//  NoStoryboardProject01
//
//  Created by 원대한 on 3/17/25.
//


import Foundation

// 프로필 정보 관리를 위한 UserDefaults 매니저
class UserDefaultsManager {
    // 싱글톤 패턴으로 구현
    static let shared = UserDefaultsManager()
    
    // UserDefaults 키 값
    private enum Keys {
        static let name = "profile_name"
        static let username = "profile_username"
        static let bio = "profile_bio"
        static let location = "profile_location"
        static let genres = "profile_genres"
    }
    
    // UserDefaults 인스턴스
    private let defaults = UserDefaults.standard
    
    // 기본값
    private let defaultName = "김도연"
    private let defaultAge = "20세"
    private let defaultBio = "음악과 함께하는 일상 🎵"
    private let defaultLocation = "서울, 대한민국"
    private let defaultGenres = ["K-POP", "R&B", "팝"]
    
    // 이름 저장 및 가져오기
    func saveName(_ name: String) {
        defaults.set(name, forKey: Keys.name)
    }
    
    func getName() -> String {
        return defaults.string(forKey: Keys.name) ?? defaultName
    }
    
    // 사용자명 저장 및 가져오기
    func saveUsername(_ username: String) {
        defaults.set(username, forKey: Keys.username)
    }
    
    func getUsername() -> String {
        return defaults.string(forKey: Keys.username) ?? defaultAge
    }
    
    // 소개 저장 및 가져오기
    func saveBio(_ bio: String) {
        defaults.set(bio, forKey: Keys.bio)
    }
    
    func getBio() -> String {
        return defaults.string(forKey: Keys.bio) ?? defaultBio
    }
    
    // 위치 저장 및 가져오기
    func saveLocation(_ location: String) {
        defaults.set(location, forKey: Keys.location)
    }
    
    func getLocation() -> String {
        return defaults.string(forKey: Keys.location) ?? defaultLocation
    }
    
    // 장르 저장 및 가져오기
    func saveGenres(_ genres: [String]) {
        defaults.set(genres, forKey: Keys.genres)
    }
    
    func getGenres() -> [String] {
        return defaults.stringArray(forKey: Keys.genres) ?? defaultGenres
    }
    
    // 모든 프로필 정보 저장
    func saveProfile(name: String, username: String? = nil, bio: String? = nil, location: String? = nil, genres: [String]) {
        saveName(name)
        if let username = username { saveUsername(username) }
        if let bio = bio { saveBio(bio) }
        if let location = location { saveLocation(location) }
        saveGenres(genres)
    }
    
    // 모든 저장된 데이터 삭제 (리셋)
    func resetAllProfileData() {
        defaults.removeObject(forKey: Keys.name)
        defaults.removeObject(forKey: Keys.username)
        defaults.removeObject(forKey: Keys.bio)
        defaults.removeObject(forKey: Keys.location)
        defaults.removeObject(forKey: Keys.genres)
    }
}

