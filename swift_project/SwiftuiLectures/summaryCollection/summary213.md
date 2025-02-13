## 네비게이션 뷰

import SwiftUI

struct NavigationExample: View {
var body: some View {
NavigationStack {
VStack {
Text("메인 화면")
.font(.largeTitle)

                NavigationLink("세부 화면으로 이동", destination: DetailView())
                    .padding()
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("메인 화면")
        }
    }

}

struct DetailView: View {
var body: some View 뷰
Text("여기는 세부 화면입니다.")
.font(.title)
.navigationTitle("세부 화면")
.navigationBarTitleDisplayMode(.inline)
}
}

#Preview {
NavigationExample()
}

```

**설명:**

- **`NavigationStack`** 뷰 래퍼는 뷰 계층 구조를 관리하고 탐색 기능을 제공합니다.
- **`NavigationLink`**는 메인 화면에서 세부 화면으로 이동하는 링크를 생성합니다.
- **`NavigationTitle`**은 메인 화면에 표시되는 제목을 설정합니다.
```

# iOS 개발 시 많이 사용되는 데이터 저장 기술

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📱 Core Data
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #2196F3; background-color: #f8f9fa;">
관계형 데이터 관리 및 오프라인 데이터에 적합 (가장 널리 사용되나 학습 곡선이 높음)
</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
⚙️ UserDefaults
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #4CAF50; background-color: #f8f9fa;">
간단한 설정 저장에 사용 (사용자 환경 설정, 앱 상태)
</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📁 FileManager
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #FF9800; background-color: #f8f9fa;">
JSON 데이터 저장 또는 사용자 콘텐츠 관리
</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
🔥 Firebase
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #F44336; background-color: #f8f9fa;">
실시간 데이터 관리 또는 채팅/협업 앱 개발
</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
☁️ CloudKit
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #9C27B0; background-color: #f8f9fa;">
클라우드 데이터 동기화 및 백업
</div>
</details>

1. Core Data : 관계형 데이터 관리 및 오프라인 데이터에 적합 (가장 널리 사용되나 학습 곡선이 높음)
2. UserDefaults : 간단한 설정 저장에 사용 (사용자 환경 설정, 앱 상태)
3. FileManager : JSON 데이터 저장 또는 사용자 콘텐츠 관리
4. Firebase : 실시간 데이터 관리 또는 채팅/협업 앱 개발
5. CloudKit : 클라우드 데이터 동기화 및 백업

## 주요 데이터 저장 기술 비교

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
💾 Core Data 상세 정보
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #2196F3; background-color: #f8f9fa;">

Core Data는 iOS의 가장 강력한 데이터 관리 프레임워크로, 다음과 같은 경우에 적합합니다:

- **복잡한 데이터 모델링**이 필요한 앱
- **관계형 데이터** 관리가 필요한 경우
- **오프라인 데이터 캐싱**이 필요한 경우
- **데이터 버전 관리**와 마이그레이션이 필요한 경우

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
⚙️ UserDefaults 상세 정보
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #4CAF50; background-color: #f8f9fa;">

UserDefaults는 간단한 데이터를 키-값 쌍으로 저장하는데 적합합니다:

- **앱 설정** 저장 (테마, 언어 등)
- **사용자 환경설정** 저장
- **앱 상태** 유지 (로그인 상태, 최근 실행 상태 등)
- **간단한 플래그값** 저장

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📁 FileManager 상세 정보
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #FF9800; background-color: #f8f9fa;">

FileManager는 파일 시스템 수준의 데이터 관리에 사용됩니다:

- **대용량 파일** 저장 (이미지, 음악, 비디오)
- **사용자 생성 콘텐츠** 관리
- **임시 파일** 관리
- **문서 기반 앱**의 파일 관리

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
🔥 Firebase 상세 정보
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #F44336; background-color: #f8f9fa;">

Firebase는 클라우드 기반 실시간 데이터 관리에 적합합니다:

- **실시간 데이터 동기화**가 필요한 앱
- **사용자 인증**이 필요한 앱
- **푸시 알림** 구현
- **다중 사용자 협업** 기능이 필요한 앱

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
☁️ CloudKit 상세 정보
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #9C27B0; background-color: #f8f9fa;">

CloudKit은 iCloud 기반 데이터 동기화에 특화되어 있습니다:

- **여러 기기 간 데이터 동기화**
- **사용자 간 데이터 공유**
- **대용량 클라우드 스토리지** 필요 시
- **오프라인 지원**이 필요한 iCloud 기반 앱

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📚 참고 자료
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #607D8B; background-color: #f8f9fa;">

- Core Data: [iOS Core Data 기본 개념 및 간단 예제](https://ukseung2.tistory.com/entry/iOS-CoreData-%EA%B8%B0%EB%B3%B8-%EA%B0%9C%EB%85%90-%EB%B0%8F-%EA%B0%84%EB%8B%A8-%EC%98%88%EC%A0%9C)
- UserDefaults: [UserDefaults와 Property List의 이해와 활용](https://f-lab.kr/insight/understanding-userdefaults-and-property-list)
- FileManager: [Swift/iOS FileManager 활용하기](https://leeari95.tistory.com/32)
- Firebase: [Firebase 사용법 가이드](https://woojong92.tistory.com/entry/JSFirebase-%EC%9B%B9-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%EB%A5%BC-%EC%9C%84%ED%95%9C-Firebase-%EC%82%AC%EC%9A%A9%EB%B2%95-1-Firebase-%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0)
- CloudKit: [CloudKit 학습 가이드](https://lafortune.tistory.com/30)

</div>
</details>

# UserDefaults 데이터 활용 가이드

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📊 UserDefaults 기본 특징
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #2196F3; background-color: #f8f9fa;">

- **데이터 크기**: 최대 512KB 권장
- **사용 대상**: 사용자 설정, 앱 상태 저장
- **데이터 형식**: String, Int, Bool, Dictionary
- **유효 기간**: 앱 삭제 시 함께 삭제
- **보안 수준**: 앱 내부 저장 (상대적 안전)
- **데이터 공유**: 동일 앱 내에서만 공유 가능

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
🎮 사용 목적
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #4CAF50; background-color: #f8f9fa;">

게임 및 앱에서 필수적인 사용자 설정 정보를 저장하는 데 활용됩니다:

- 게임 설정
- 사용자 기본 설정
- 앱 상태 정보

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
✨ 주요 특징
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #FF9800; background-color: #f8f9fa;">

1. **간단한 API** 제공
2. **데이터 크기** 제한
3. **데이터 형식** 제한
4. **데이터 유효 기간** 제한
5. **데이터 공유** 제한

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
⚠️ 주의사항
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #F44336; background-color: #f8f9fa;">

1. **보안에 민감한 데이터는 저장하지 않기**
2. **소량의 필수 키-값 데이터만 저장하기**
3. **대용량 데이터는 CloudKit 사용 권장**

</div>
</details>

# UserDefaults 사용 예제

## **SwiftUI에서 UserDefaults 사용법**

**⚠️ 주의: 프리뷰에서 UserDefaults 테스트 할 경우에는** 프리뷰를 다시 실행할 때 값이 **초기화** 될 수 있습니다.

---

### **1. UserDefaults로 데이터 저장 및 읽기**

**데이터 저장 (`set(_:forKey:)`)**

```swift
UserDefaults.standard.set(true, forKey: "isDarkMode")
UserDefaults.standard.set(25, forKey: "userAge")
UserDefaults.standard.set("John", forKey: "userName")
```

**데이터 읽기 (`bool(forKey:)`, `integer(forKey:)`, `string(forKey:)`)**

```swift
let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
let userAge = UserDefaults.standard.integer(forKey: "userAge")
let userName = UserDefaults.standard.string(forKey: "userName") ?? "Unknown"

```

![image.png](image.png)

# 데이터 저장 - FileMananger

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
방법2: FileManager 사용하기
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #4CAF50; background-color: #f8f9fa;">

SwiftUI에서 **FileManager**를 사용하는 방법은 **앱의 문서 디렉토리나 캐시 디렉토리**에 **JSON 파일, 이미지, 사용자 생성 데이터**를 저장하거나 읽어올 때 매우 유용합니다. **FileManager**를 사용해 데이터를 **저장, 읽기, 삭제, 검사**할 수 있습니다.

</div>
</details>

<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
1. FileManager 주요 개념
</summary>
<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #2196F3; background-color: #f8f9fa;">

### FileManager란?

- **iOS 파일 시스템**에 접근할 수 있게 해주는 **Swift 클래스**입니다.
- **문서 디렉토리 (Document Directory)**에 데이터를 저장하거나 가져올 때 사용합니다.
- **이미지, JSON 파일, 사용자 생성 콘텐츠** 관리에 적합합니다.

</div>
</details>

## 2. 기본 사용 예제

### 2.1 파일 저장 위치 설정

파일을 저장할 디렉토리는 보통 문서 디렉토리 (Documents)를 사용합니다.

# 요약

# FileManager 핵심 가이드

## 목차

- [1. FileManager 기본 개념](#1-filemanager-기본-개념)
- [2. 저장소 위치 관리](#2-저장소-위치-관리)
- [3. Codable 프로토콜과 데이터 변환](#3-codable-프로토콜과-데이터-변환)
- [4. 데이터 저장 및 불러오기 프로세스](#4-데이터-저장-및-불러오기-프로세스)
- [5. 이미지 처리](#5-이미지-처리)

<details>
<summary> 1. FileManager 기본 개념</summary>

### FileManager의 역할

iOS 파일 시스템에 접근하여 데이터를 관리하는 중앙 관리자입니다.

> 💡 **실생활 비유**  
> FileManager는 대형 건물의 관리인과 같습니다:
>
> - 건물의 모든 방(저장 공간)에 대한 열쇠(접근 권한)를 보유
> - 필요한 공간을 할당하고 관리
> - 건물 내 모든 시설의 위치 정보 파악

### 주요 특징

- 파일 시스템 접근 권한 관리
- 데이터 저장/로드 기능
- 파일/디렉토리 생성, 삭제, 이동
</details>

<details>
<summary> 2. 저장소 위치 관리</summary>

### 문서 디렉토리 접근 흐름

```swift
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let fileURL = documentDirectory.appendingPathComponent("example.json")
```

> 💡 **실생활 비유**  
> 건물 내 특정 사무실을 찾아가는 과정:
>
> 1. 건물 안내도 확인 (`FileManager.default`)
> 2. 해당 층 찾기 (`.documentDirectory`)
> 3. 구체적인 호수 찾기 (`appendingPathComponent`)

### 주요 저장 위치

1. Documents Directory: 사용자 데이터
2. Caches Directory: 임시 데이터
3. Application Support Directory: 앱 지원 파일
</details>

<details>
<summary> 3. Codable 프로토콜과 데이터 변환</summary>

### 데이터 변환 프로세스

객체와 JSON 데이터 간의 변환을 담당합니다.

```swift
struct User: Codable {
    var name: String
    var age: Int
}
```

> 💡 **실생활 비유**  
> Codable은 번역가와 같은 역할:
>
> - Swift 객체 → JSON (한국어 → 영어)
> - JSON → Swift 객체 (영어 → 한국어)

### 주요 기능

- Encoding: 객체를 데이터로 변환
- Decoding: 데이터를 객체로 변환
</details>

<details>
<summary> 4. 데이터 저장 및 불러오기 프로세스</summary>

### 데이터 처리 흐름

```swift
// 저장
let encoder = JSONEncoder()
let data = try encoder.encode(user)
try data.write(to: fileURL)

// 불러오기
let data = try Data(contentsOf: fileURL)
let decoder = JSONDecoder()
let user = try decoder.decode(User.self, from: data)
```

> 💡 **실생활 비유**  
> 택배 시스템과 유사:
>
> - 포장(Encode): 물건을 박스에 담기
> - 배송(Save): 박스를 창고에 보관
> - 수령(Load): 창고에서 박스 찾기
> - 개봉(Decode): 박스에서 물건 꺼내기

### 주요 단계

1. 데이터 변환 (Encoding/Decoding)
2. 파일 시스템 접근
3. 데이터 저장/로드
4. 오류 처리
</details>

<details>
<summary> 5. 이미지 처리</summary>

### 이미지 데이터 처리 과정

```swift
// 저장
if let data = image.jpegData(compressionQuality: 0.8) {
    try data.write(to: fileURL)
}

// 불러오기
if let data = try? Data(contentsOf: fileURL) {
    let image = UIImage(data: data)
}
```

> 💡 **실생활 비유**  
> 사진관의 작업 과정과 유사:
>
> - 사진 촬영 (이미지 생성)
> - 디지털 파일로 변환 (Data 변환)
> - 저장소에 보관 (파일 저장)
> - 필요할 때 인화 (파일 불러오기)

### 주요 고려사항

- 이미지 압축률
- 저장 공간 관리
- 메모리 효율성
</details>

---

## 📌 주의사항

1. **저장 위치 선택**

   - UserDefaults: 작은 설정 데이터
   - FileManager: 큰 파일, 이미지
   - CoreData: 관계형 데이터

2. **오류 처리**

   - 파일 존재 여부 확인
   - 저장 공간 확인
   - 권한 확인

3. **메모리 관리**
   - 큰 파일 처리 시 메모리 고려
   - 적절한 캐싱 전략 수립
