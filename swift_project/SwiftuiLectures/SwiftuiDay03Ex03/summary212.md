# 4-1 기본기 다지기: 프리뷰(Preview)

SwiftUI의 프리뷰(Preview)는 **UI 구성 요소를 실시간으로 확인할 수 있는 강력한 도구**입니다. 이번 단원에서는 **프리뷰 동작 과정**, **최적화 레벨**, **프리뷰 오류 메시지 해결법**, **자동 갱신 중단 방법**, **환경 값(EnvironmentValues)**, 그리고 **커스텀 환경 값**까지 상세히 살펴보겠습니다.

---

<!-- 프리뷰 기본 개념 -->
<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📌 핵심 개념 1: 프리뷰(Preview)의 본질
</summary>

<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #2196F3; background-color: #f8f9fa;">

### **1. 프리뷰(Preview)란?**

프리뷰는 **SwiftUI의 UI 구성 요소를 빌드하지 않고 실시간으로 미리 볼 수 있는 기능**으로:

- Xcode Canvas에서 즉각적인 피드백 가능
- 다양한 디바이스 크기 테스트 용이
- 코드 수정 → UI 변경 즉시 반영

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro")
    }
}
```

<div style="margin-top: 15px; padding: 10px; border: 1px solid #e0e0e0; border-radius: 5px;">
💡 **느낀점**  
프리뷰 기능을 활용하면 실제 빌드 시간을 절약하면서 다양한 UI 시나리오를 빠르게 테스트할 수 있어 개발 효율성이 크게 향상됩니다. 특히 `.previewDevice` 수식어를 통해 여러 기기 레이아웃을 동시에 확인할 수 있는 점이 가장 유용하게 느껴졌습니다.
</div>
</div>
</details>

---

## **2. 프리뷰 동작 과정**

프리뷰는 **PreviewProvider 프로토콜**을 준수하는 구조체에 의해 동작합니다.

### **프리뷰의 주요 동작 과정**

1. **SwiftUI 뷰를 PreviewProvider 내부에서 반환**
   - `static var previews` 프로퍼티에서 뷰를 반환합니다.
2. **Canvas에 UI 렌더링**
   - Canvas가 PreviewProvider의 내용을 읽고, SwiftUI 뷰를 실시간으로 렌더링합니다.
3. **변경 사항 자동 반영**
   - 코드 수정 시 자동으로 Canvas에 변경 사항이 적용됩니다.

---

## **3. Swift 최적화 레벨과 프리뷰 성능**

프리뷰는 **Swift 최적화 레벨**에 따라 성능이 달라집니다.

### **최적화 레벨 비교**

| **최적화 레벨**      | **설명**             | **프리뷰 성능**     |
| -------------------- | -------------------- | ------------------- |
| **Debug (-Onone)**   | 디버그 최적화 없음   | 빠른 코드 수정 확인 |
| **Release (-O)**     | 최적화 활성화        | 느리지만 최종 성능  |
| **Partial (-Osize)** | 크기 최적화 (-Osize) | 크기 중심 최적화    |

### **권장 설정**

- **디버그 모드 (-Onone)**에서 **빠른 피드백**을 위해 최적화를 비활성화합니다.
- 최종 릴리스 전에 **Release 모드**에서 최적화를 테스트합니다.

---

## **4. 프리뷰 오류 메시지 해결**

프리뷰 오류 메시지는 다양한 이유로 발생할 수 있습니다.

**대표적인 오류와 해결 방법**을 정리했습니다.

| **오류 메시지**              | **원인 및 해결책**                                 |
| ---------------------------- | -------------------------------------------------- |
| **No Preview Available**     | PreviewProvider 누락, Canvas 비활성화 확인         |
| **Failed to Launch Preview** | 빌드 실패, 코드 오류 또는 환경 설정 오류           |
| **Crash 발생 시**            | `@State` 등 초기화되지 않은 값 확인                |
| **Canvas가 멈췄을 때**       | `⌘ + Option + P`로 프리뷰 재실행 또는 Xcode 재시작 |

---

## **5. 자동 프리뷰 갱신 중단**

자동 프리뷰 갱신은 개발 중 Canvas가 느려지는 원인이 될 수 있습니다.

이 경우 **자동 갱신을 비활성화**하고 **수동 갱신**을 사용합니다.

### **자동 갱신 중단 방법**

- **Canvas 오른쪽 상단의 Auto Update 버튼 해제**
- `⌘ + Option + P` 키로 수동으로 프리뷰 갱신

---

## **6. 프리뷰 수식어 살펴보기**

프리뷰는 다양한 수식어를 제공해 **디자인 테스트를 간편화**할 수 있습니다.

---

### **6.1 기기 지정하기**

`previewDevice` 수식어를 사용해 **다양한 기기에서 UI를 테스트**할 수 있습니다.

```swift
ContentView()
    .previewDevice("iPhone 13")

```

**대표 기기 목록:**

- iPhone 13
- iPad Pro (11-inch)
- Apple Watch Series 7

---

### **6.2 레이아웃 변경하기**

`previewLayout` 수식어를 사용해 **레이아웃을 커스터마이징**할 수 있습니다.

```swift
ContentView()
    .previewLayout(.sizeThatFits)
    .padding()

```

- **`.sizeThatFits`**: 뷰의 **이상적인 크기**로 미리봅니다.
- **`.fixed(width:height:)`**: **고정된 크기**로 미리봅니다.

---

## **7. EnvironmentValues와 @Environment**

SwiftUI의 **Environment**는 **공통 데이터나 설정을 뷰 계층 전체에 전달**할 때 사용합니다.

---

<!-- EnvironmentValues 설명 -->
<details>
<summary style="cursor: pointer; font-weight: bold; padding: 8px; background-color: #f5f5f5; border-radius: 5px;">
📌 핵심 개념 2: 환경 값 관리
</summary>

<div style="margin: 15px 0; padding: 10px; border-left: 4px solid #4CAF50; background-color: #f8f9fa;">

### **7. EnvironmentValues**

**EnvironmentValues**는 SwiftUI가 제공하는 **기본 환경 값 컬렉션**입니다.

```swift
struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text("Current Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
    }
}

```

**설명:**

- *`.colorScheme`*는 **현재 다크 모드 또는 라이트 모드 여부**를 반환합니다.
- **EnvironmentValues**는 **사용자 환경 설정**에 따라 UI를 조정할 때 유용합니다.

### **7.2 environment 수식어**

`environment` 수식어로 **자식 뷰에 환경 값을 전달**할 수 있습니다.

```swift
ContentView()
    .environment(\.font, Font.headline)

```

**설명:**

- **`.font`** 키를 사용해 **모든 자식 뷰의 폰트를 headline으로 설정**합니다.

### **7.3 @Environment**

`@Environment`는 **EnvironmentValues에 저장된 값을 쉽게 읽기** 위한 **속성 래퍼**입니다.

### **7.4 Custom Environment 만들기**

사용자 정의 **Environment 키**를 만들어 **앱 전역에서 공유할 데이터**를 관리할 수 있습니다.

```swift
struct CustomEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = "기본 값"
}

extension EnvironmentValues {
    var customValue: String {
        get { self[CustomEnvironmentKey.self] }
        set { self[CustomEnvironmentKey.self] = newValue }
    }
}

struct ContentView: View {
    @Environment(\.customValue) var customValue

    var body: some View {
        Text("Custom Value: \(customValue)")
    }
}

```

### **설명:**

- **`EnvironmentKey`** 프로토콜을 사용해 **커스텀 환경 키**를 정의합니다.
- *`@Environment(\.customValue)`*로 **해당 값을 읽어올 수 있습니다.**

</div>
</details>

---

## **정리**

- **프리뷰(Preview)**는 **실시간 UI 확인과 테스트**를 위한 강력한 도구입니다.
- **프리뷰 수식어**를 사용해 **기기, 레이아웃, 환경 값**을 테스트할 수 있습니다.
- **EnvironmentValues와 @Environment**를 사용해 **공통 데이터**를 손쉽게 관리할 수 있습니다.
- **커스텀 환경 값**을 정의해 **전역 상태 관리**를 확장할 수 있습니다.

---

# **다양한 프리뷰 활용과 상태 관리**

이번 단원에서는 **SwiftUI의 다양한 프리뷰 활용과 상태 관리**를 실전 예제를 통해 학습합니다. 상태 관리(State, Binding, ObservedObject, EnvironmentObject)**와 이를 **프리뷰에서 테스트하는 방법\*\*을 상세히 다룰 것입니다.

---

## **1. 프리뷰에서 상태 관리**

SwiftUI에서 **상태(State)**를 사용하면 UI가 **데이터 변경에 반응**하도록 만들 수 있습니다.

프리뷰에서도 **상태를 시뮬레이션**하여 다양한 상황을 테스트할 수 있습니다.

---

### **1.1 @State를 프리뷰에서 활용하기**

`@State`는 **뷰 내부의 상태 값**을 관리합니다.

프리뷰에서는 `@State` 값을 초기화하여 **다양한 상태를 테스트**할 수 있습니다.

```swift
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
                .font(.largeTitle)
            Button("Increase") {
                count += 1
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CounterView()
                .previewDisplayName("Default State")
            CounterView()
                .environment(\.locale, .init(identifier: "ko"))
                .previewDisplayName("Korean Locale")
        }
    }
}

```

### **설명:**

- *`@State`*를 사용해 **카운터 값을 관리**합니다.
- **프리뷰에서 로케일 설정**을 변경해 다국어 지원도 테스트할 수 있습니다.

---

## **2. Binding과 프리뷰 테스트**

- *`@Binding`*은 **부모 뷰와 자식 뷰 간의 상태 공유**를 가능하게 합니다.

프리뷰에서는 **`State` 값을 Binding으로 전달**해 테스트할 수 있습니다.

---

### **2.1 Binding 사용 예제**

```swift
struct ToggleView: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text("Toggle Switch")
        }
        .padding()
    }
}

struct ToggleView_Previews: PreviewProvider {
    @State static var isOn = true

    static var previews: some View {
        ToggleView(isOn: $isOn)
    }
}

```

### **설명:**

- *`@Binding`*은 **부모 뷰에서 전달된 상태 값을 사용**합니다.
- **`@State`를 프리뷰에서 Binding으로 전달**해 시뮬레이션할 수 있습니다.

---

## **3. ObservedObject와 EnvironmentObject**

`@ObservedObject`와 `@EnvironmentObject`는 **더 큰 범위의 상태 관리**를 제공합니다.

이를 사용하면 **데이터 모델과 뷰 간의 데이터 흐름**을 쉽게 관리할 수 있습니다.

---

### **3.1 @ObservedObject 사용 예제**

**Step 1: 데이터 모델 생성**

```swift
import SwiftUI
import Combine

class CounterModel: ObservableObject {
    @Published var count = 0
}

```

**Step 2: CounterView에 적용**

```swift
struct CounterView: View {
    @ObservedObject var model: CounterModel

    var body: some View {
        VStack {
            Text("Count: \(model.count)")
                .font(.largeTitle)
            Button("Increase") {
                model.count += 1
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

```

**Step 3: 프리뷰에서 테스트**

```swift
struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(model: CounterModel())
    }
}

```

### **설명:**

- `@ObservedObject`는 **외부 데이터 모델**을 주시합니다.
- `@Published`로 선언된 프로퍼티가 변경될 때 UI가 자동으로 업데이트됩니다.

---

### **3.2 @EnvironmentObject 사용 예제**

**Step 1: 공통 데이터 모델 생성**

```swift
class UserSettings: ObservableObject {
    @Published var username: String = "Guest"
}

```

**Step 2: 여러 뷰에서 공유하기**

```swift
struct ContentView: View {
    var body: some View {
        NavigationView {
            ProfileView()
                .environmentObject(UserSettings())
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        VStack {
            Text("Username: \(settings.username)")
                .font(.title)
            Button("Change Username") {
                settings.username = "SwiftUser"
            }
        }
        .padding()
    }
}

```

**Step 3: 프리뷰에서 테스트**

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}

```

### **설명:**

- `@EnvironmentObject`는 **여러 뷰에서 공통 데이터를 공유**할 때 사용합니다.
- **프리뷰에서도 environmentObject로 데이터 모델을 전달**해야 오류가 발생하지 않습니다.

---

## **4. 다양한 프리뷰 시나리오 구성**

프리뷰는 **다양한 상황을 시뮬레이션**할 수 있습니다. **여러 시나리오를 그룹화**해 테스트합니다.

### **4.1 시나리오 기반 프리뷰**

```swift
struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CounterView(model: CounterModel())
                .previewDisplayName("Default State")

            CounterView(model: {
                let model = CounterModel()
                model.count = 10
                return model
            }())
            .previewDisplayName("Count at 10")
        }
    }
}

```

---

## **5. 정리**

- **프리뷰**는 **상태 관리(State, Binding, ObservedObject, EnvironmentObject)**를 **실제 앱의 다양한 상황에서 테스트**할 수 있습니다.
- **Binding과 State**를 활용해 **부모-자식 간의 상태 공유**를 확인할 수 있습니다.
- *`@ObservedObject`와 `@EnvironmentObject`*는 **더 큰 범위의 데이터 흐름 관리**에 적합합니다.
- **다양한 시나리오를 그룹화**해 프리뷰 테스트를 확장할 수 있습니다.

---

다음으로 **상태 관리 심화 (StateObject, AppStorage, SceneStorage)** 또는 **SwiftUI 애니메이션 심화** 중 어떤 주제로 이어서 작성할까요? 😊

# **StateObject, AppStorage, SceneStorage**

SwiftUI의 **상태 관리(State Management)**는 앱 데이터 흐름을 쉽게 관리할 수 있도록 설계되었습니다.

이번 단원에서는 **StateObject**, **AppStorage**, **SceneStorage**의 사용법과 **상황에 따른 선택 기준**을 다룹니다.

---

## **1. @StateObject**

- *`@StateObject`*는 **ObservableObject의 인스턴스를 뷰의 수명 동안 유지**하는 데 사용됩니다. **뷰가 생성될 때 한 번만 초기화**되며, 뷰가 재생성되더라도 동일한 객체를 유지합니다.

### **1.1 @StateObject와 @ObservedObject 비교**

| **@StateObject**                             | **@ObservedObject**                       |
| -------------------------------------------- | ----------------------------------------- |
| **뷰 내부에서 객체 생성 및 관리**            | **외부에서 전달받은 객체 관리**           |
| 뷰가 재생성돼도 **객체가 유지됨**            | **뷰가 재생성되면 객체도 초기화됨**       |
| 주로 **새로운 데이터 모델을 생성**할 때 사용 | **부모 뷰로부터 전달된 데이터 모델** 사용 |

---

### **1.2 @StateObject 사용 예제**

**Step 1: 데이터 모델 생성**

```swift
import SwiftUI
import Combine

class CounterModel: ObservableObject {
    @Published var count = 0
}

```

**Step 2: @StateObject 사용**

```swift
struct CounterView: View {
    @StateObject private var model = CounterModel()

    var body: some View {
        VStack {
            Text("Count: \(model.count)")
                .font(.largeTitle)
            Button("Increase") {
                model.count += 1
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

```

### **설명:**

- *`@StateObject`*로 **CounterModel**의 인스턴스를 생성하고 관리합니다.
- **뷰가 재생성되더라도 모델의 상태가 유지**됩니다.

---

## **2. @AppStorage**

- *`@AppStorage`*는 **UserDefaults에 데이터를 저장**하고 관리할 수 있는 **속성 래퍼**입니다. **앱 전역에 걸쳐 데이터를 영구적으로 저장**할 때 사용합니다.

---

### **2.1 기본 사용 예제**

```swift
struct SettingsView: View {
    @AppStorage("username") private var username: String = "Guest"

    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }
}

```

### **설명:**

- *`@AppStorage("username")`*는 **UserDefaults에 `username` 키로 데이터를 저장**합니다.
- **TextField**에서 값을 수정하면 자동으로 **UserDefaults**에 저장됩니다.
- 앱을 다시 실행해도 **저장된 값이 유지**됩니다.

---

### **2.2 AppStorage의 데이터 유형**

- *`@AppStorage`*는 다양한 기본 데이터 유형을 지원합니다.

| **지원 데이터 유형** | **설명**             |
| -------------------- | -------------------- |
| **String**           | 문자열 저장          |
| **Int**              | 정수 값 저장         |
| **Double**           | 실수 값 저장         |
| **Bool**             | 논리 값 저장         |
| **Data**             | 바이너리 데이터 저장 |

**예시:**

```swift
@AppStorage("isDarkMode") private var isDarkMode = false

```

---

## **3. @SceneStorage**

- *`@SceneStorage`*는 **앱의 특정 장면(Scene)에 데이터를 저장**합니다.

**앱이 백그라운드로 전환되거나 종료된 후에도 해당 장면이 복구**될 때 **저장된 데이터가 유지**됩니다.

---

### **3.1 SceneStorage 기본 사용 예제**

```swift
struct NotesView: View {
    @SceneStorage("noteText") private var noteText: String = ""

    var body: some View {
        VStack {
            TextEditor(text: $noteText)
                .frame(height: 200)
                .border(Color.gray)
            Text("Saved Text: \(noteText)")
                .padding()
        }
        .padding()
    }
}

```

### **설명:**

- *`@SceneStorage("noteText")`*는 **앱의 현재 Scene에 데이터를 저장**합니다.
- 앱이 다시 활성화되면 **마지막으로 입력된 값이 복원**됩니다.

---

## **4. @StateObject, AppStorage, SceneStorage 사용 시기**

| **속성 래퍼**     | **사용 시기**                      | **데이터 유지 범위**      |
| ----------------- | ---------------------------------- | ------------------------- |
| **@StateObject**  | **뷰 내부 상태** 관리              | **뷰의 수명 동안 유지**   |
| **@AppStorage**   | **영구 데이터 저장(UserDefaults)** | **앱 전체에서 사용 가능** |
| **@SceneStorage** | **Scene 복구용 데이터 관리**       | **Scene 단위로 유지**     |

---

## **5. 실전 예제: 모든 상태 관리 통합**

이제 **`@StateObject`, `@AppStorage`, `@SceneStorage`**를 통합한 실전 예제를 만들어 보겠습니다.

```swift
struct CombinedStateView: View {
    @StateObject private var counterModel = CounterModel()
    @AppStorage("username") private var username: String = "Guest"
    @SceneStorage("noteText") private var noteText: String = ""

    var body: some View {
        VStack {
            // StateObject 사용 예제
            Text("Count: \(counterModel.count)")
                .font(.title)
            Button("Increase Count") {
                counterModel.count += 1
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            // AppStorage 사용 예제
            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // SceneStorage 사용 예제
            TextEditor(text: $noteText)
                .frame(height: 100)
                .border(Color.gray)
                .padding()
        }
        .padding()
    }
}

```

### **설명:**

- *`@StateObject`*로 **카운터 모델**의 상태를 관리합니다.
- *`@AppStorage`*로 **사용자 이름**을 저장하고 유지합니다.
- *`@SceneStorage`*로 **메모 내용**을 저장하고 **Scene 복구** 시 복원합니다.

---

## **6. 정리**

- *`@StateObject`*는 **뷰 내부의 상태 객체를 관리**하며, 뷰가 재생성돼도 동일 객체를 유지합니다.
- *`@AppStorage`*는 **UserDefaults에 데이터를 영구 저장**하며, 앱 전역에서 사용할 수 있습니다.
- *`@SceneStorage`*는 **Scene 단위로 데이터를 유지 및 복원**합니다.
- **상태 관리 전략**을 올바르게 선택하면 **더 안정적이고 유지보수하기 쉬운 앱**을 개발할 수 있습니다.

---

# **Combine을 활용한 데이터 흐름 관리**

**Combine**은 **애플의 리액티브 프로그래밍 프레임워크**로, Swift에서 **비동기 이벤트 처리를 선언형으로** 수행할 수 있도록 지원합니다. Combine은 SwiftUI와 잘 통합되어 **데이터 흐름 관리** 및 **UI 업데이트**를 효율적으로 처리할 수 있습니다.

이번 단원에서는 Combine의 **기본 개념**, **핵심 요소(Publisher, Subscriber, Operator)**, **SwiftUI와의 통합**, 그리고 **실전 예제**를 다루어 **데이터 흐름을 효과적으로 관리하는 방법**을 학습합니다.

---

## **1. Combine의 핵심 개념**

Combine은 **Publisher-Subscriber 패턴**을 기반으로 동작합니다.

**Publisher**는 **데이터 이벤트**를 방출하고, **Subscriber**는 해당 이벤트를 **구독하여 처리**합니다.

### **1.1 Combine의 주요 요소**

| **요소**       | **설명**                                  |
| -------------- | ----------------------------------------- |
| **Publisher**  | 데이터를 생성하고 방출하는 객체           |
| **Subscriber** | 데이터를 구독하고 이벤트를 처리하는 객체  |
| **Operator**   | 데이터를 변환하거나 필터링하는 중간 작업  |
| **Subject**    | Publisher와 Subscriber의 역할을 모두 수행 |

---

### **1.2 데이터 흐름 예시**

1. **Publisher**가 데이터를 생성하고 방출합니다.
2. **Subscriber**가 데이터를 구독하고 처리합니다.
3. **Operator**를 사용해 데이터를 변환하거나 필터링할 수 있습니다.

```swift
import Combine

let publisher = [1, 2, 3, 4, 5].publisher

let subscription = publisher
    .filter { $0 % 2 == 0 }
    .sink { value in
        print("Received value: \(value)")
    }

```

**출력:**

```
Received value: 2
Received value: 4

```

---

## **2. Publisher와 Subscriber**

### **2.1 Publisher**

**Publisher**는 데이터를 방출하고, **구독자가 이벤트를 받을 수 있도록** 지원합니다.

**기본 Publisher 예제:**

```swift
let publisher = Just("Hello, Combine!")
publisher.sink { value in
    print(value)
}

```

**출력:**

```
Hello, Combine!

```

**대표적인 Publisher:**

- **Just**: 단일 값을 방출
- **Future**: 비동기 작업의 결과 방출
- **PassthroughSubject**: 다수의 값을 방출하며 직접 제어 가능
- **CurrentValueSubject**: 초기값과 최신값을 유지하며 방출

---

### **2.2 Subscriber**

**Subscriber**는 Publisher의 이벤트를 **구독하고 처리**합니다.

**Subscriber를 생성하는 방식:**

- **sink**: 값을 수신하고 처리할 때 사용
- **assign**: 값을 특정 프로퍼티에 할당할 때 사용

```swift
import Combine

let publisher = Just("SwiftUI")
publisher
    .sink { value in
        print("Received: \(value)")
    }

```

---

## **3. Operator 활용**

**Operator**는 **Publisher의 데이터를 변환하거나 필터링**하는 역할을 합니다.

다양한 Operator를 조합해 **복잡한 데이터 흐름**을 간단히 처리할 수 있습니다.

### **3.1 주요 Operator 예제**

| **Operator**      | **설명**                              | **예제**                      |
| ----------------- | ------------------------------------- | ----------------------------- |
| **map**           | 데이터를 변환                         | `.map { $0 * 2 }`             |
| **filter**        | 특정 조건을 만족하는 값만 통과        | `.filter { $0 > 10 }`         |
| **combineLatest** | 여러 Publisher의 최신 값을 조합       | `.combineLatest(publisher2)`  |
| **merge**         | 여러 Publisher의 이벤트를 하나로 병합 | `.merge(with: publisher2)`    |
| **debounce**      | 특정 시간 동안 이벤트 방출을 제한     | `.debounce(for: .seconds(1))` |

---

### **3.2 map과 filter 예제**

```swift
let publisher = [1, 2, 3, 4, 5].publisher

publisher
    .map { $0 * 2 }
    .filter { $0 > 5 }
    .sink { value in
        print("Transformed value: \(value)")
    }

```

**출력:**

```
Transformed value: 6
Transformed value: 8
Transformed value: 10

```

---

## **4. Combine과 SwiftUI 통합**

**Combine**은 **SwiftUI와 긴밀하게 통합**되어 **UI 상태 관리와 데이터 흐름을 쉽게 처리**할 수 있습니다.

**ObservableObject**와 **@Published**는 Combine의 핵심 개념을 활용해 SwiftUI 뷰를 자동으로 업데이트합니다.

---

### **4.1 ObservableObject와 @Published**

- *`@Published`*는 **Combine의 Publisher**로, 값이 변경될 때 **자동으로 SwiftUI 뷰를 업데이트**합니다.

**`ObservableObject`**는 SwiftUI에서 **데이터 모델을 관찰할 수 있는 클래스**입니다.

```swift
import SwiftUI
import Combine

class CounterModel: ObservableObject {
    @Published var count = 0
}

struct CounterView: View {
    @StateObject private var model = CounterModel()

    var body: some View {
        VStack {
            Text("Count: \(model.count)")
                .font(.largeTitle)
            Button("Increase") {
                model.count += 1
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

```

**설명:**

- *`@Published`*가 선언된 **`count`** 값이 변경될 때마다 **UI가 자동으로 업데이트**됩니다.
- *`@StateObject`*로 CounterModel을 관리합니다.

---

### **4.2 combineLatest와 SwiftUI 통합 예제**

```swift
import SwiftUI
import Combine

class FormModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
}

struct LoginFormView: View {
    @StateObject private var formModel = FormModel()

    var body: some View {
        VStack {
            TextField("Username", text: $formModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $formModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Login Button Enabled: \(isLoginButtonEnabled ? "Yes" : "No")")
        }
        .padding()
    }

    var isLoginButtonEnabled: Bool {
        !formModel.username.isEmpty && !formModel.password.isEmpty
    }
}

```

---

## **5. 실전 예제: 뉴스 앱 만들기**

**Combine과 SwiftUI**를 사용해 **간단한 뉴스 앱**을 만들어 보겠습니다.

### **Step 1: 뉴스 데이터 모델 생성**

```swift
struct News: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

```

---

### **Step 2: Combine을 사용해 뉴스 데이터 가져오기**

```swift
import Combine

class NewsService {
    func fetchNews() -> AnyPublisher<[News], Never> {
        let sampleNews = [
            News(title: "SwiftUI", description: "Learn SwiftUI with Combine"),
            News(title: "Combine", description: "Reactive Programming in Swift")
        ]
        return Just(sampleNews)
            .eraseToAnyPublisher()
    }
}

```

---

### **Step 3: 뉴스 데이터 표시하기**

```swift
import SwiftUI

struct NewsListView: View {
    @State private var newsList: [News] = []
    private let newsService = NewsService()
    private var cancellable: AnyCancellable?

    var body: some View {
        List(newsList) { news in
            VStack(alignment: .leading) {
                Text(news.title)
                    .font(.headline)
                Text(news.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            cancellable = newsService.fetchNews()
                .sink { news in
                    self.newsList = news
                }
        }
    }
}

```

---

## **6. 정리**

- **Combine**은 **비동기 데이터 흐름을 선언형으로 관리**할 수 있는 강력한 프레임워크입니다.
- **Publisher와 Subscriber** 패턴을 사용해 **데이터 방출과 구독을 쉽게 처리**할 수 있습니다.
- **SwiftUI와 Combine**의 통합을 통해 **UI와 데이터 흐름을 간결하고 효율적으로 관리**할 수 있습니다.
- **실전 예제**를 통해 Combine을 **네트워킹, 폼 검증, 상태 관리**에 활용할 수 있습니다.
