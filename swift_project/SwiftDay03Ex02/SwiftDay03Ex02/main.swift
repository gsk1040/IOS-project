import Foundation

// 문제 유형 열거형
enum QuestionType {
    case multipleChoice  // 객관식
    case shortAnswer     // 주관식 단답형
    case trueFalse      // OX 문제
}

// 시험 정보 구조체
struct ExamInfo {
    let subject: String          // 과목명
    let chapter: String          // 단원
    let subChapter: String      // 세부 단원
    let examType: String        // 시험 종류
    let detailedScope: String   // 상세 범위
}

// 문제 구조체
struct Question {
    let type: QuestionType
    let content: String
    let choices: [String]?      // 객관식일 경우의 보기들
    let correctAnswer: String   // 정답
    let explanation: String?    // 해설
}

// OpenAI 요청/응답 구조체
struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

// 시험 관리 클래스
class ExamManager {
    private let apiKey: String
    private var examInfo: ExamInfo
    private let urlString = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String, examInfo: ExamInfo) {
        self.apiKey = apiKey
        self.examInfo = examInfo
    }
    
    // 문제 생성을 위한 상세 프롬프트 생성
    private func createDetailedPrompt(for type: QuestionType) -> String {
        let basePrompt = """
        다음 시험 정보를 바탕으로 문제를 생성해주세요:
        과목: \(examInfo.subject)
        단원: \(examInfo.chapter)
        세부단원: \(examInfo.subChapter)
        시험종류: \(examInfo.examType)
        시험범위: \(examInfo.detailedScope)
        
        다음 형식의 JSON으로 응답해주세요:
        {
            "content": "문제 내용",
            "correctAnswer": "정답",
            "explanation": "해설"
        """
        
        switch type {
        case .multipleChoice:
            return basePrompt + """
            ,
            "choices": ["보기1", "보기2", "보기3", "보기4"],
            "choiceExplanations": {
                "1": "1번 보기가 정답/오답인 이유",
                "2": "2번 보기가 정답/오답인 이유",
                "3": "3번 보기가 정답/오답인 이유",
                "4": "4번 보기가 정답/오답인 이유"
            }
            }
            문제는 반드시 위 시험범위에서만 출제해주세요.
            각 보기에 대해 왜 정답 또는 오답인지 구체적으로 설명해주세요.
            """
        case .shortAnswer:
            return basePrompt + """
            }
            답은 간단명료한 단답형으로 작성해주세요.
            문제는 반드시 위 시험범위에서만 출제해주세요.
            """
        case .trueFalse:
            return basePrompt + """
            }
            답은 "참" 또는 "거짓"으로만 작성해주세요.
            문제는 반드시 위 시험범위에서만 출제해주세요.
            """
        }
    }
    
    // API를 통한 문제 생성
    func generateQuestion(type: QuestionType, completion: @escaping (Result<Question, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = createDetailedPrompt(for: type)
        let openAIRequest = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: [OpenAIRequest.Message(role: "user", content: prompt)],
            temperature: 0.7
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(openAIRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                guard let content = response.choices.first?.message.content,
                      let jsonData = content.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                }
                
                let question = try self.parseQuestionFromJSON(json: json, type: type)
                completion(.success(question))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // JSON 파싱
    private func parseQuestionFromJSON(json: [String: Any], type: QuestionType) throws -> Question {
        guard let content = json["content"] as? String,
              let correctAnswer = json["correctAnswer"] as? String,
              let explanation = json["explanation"] as? String else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing required fields"])
        }
        
        var choices: [String]? = nil
        if type == .multipleChoice {
            guard let choicesArray = json["choices"] as? [String] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing choices for multiple choice question"])
            }
            choices = choicesArray
        }
        
        return Question(
            type: type,
            content: content,
            choices: choices,
            correctAnswer: correctAnswer,
            explanation: explanation
        )
    }
}

// 사용자 입력 처리
func getUserInput(prompt: String) -> String {
    print(prompt, terminator: " ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

// 메인 실행 코드
print("=== 시험 대비 문제 생성기 ===\n")

// API 키 입력
let apiKey = getUserInput(prompt: "OpenAI API 키를 입력하세요:")

// 시험 정보 입력
let subject = getUserInput(prompt: "과목명을 입력하세요:")
let chapter = getUserInput(prompt: "단원을 입력하세요:")
let subChapter = getUserInput(prompt: "세부 단원을 입력하세요:")
let examType = getUserInput(prompt: "시험 종류를 입력하세요:")
let detailedScope = getUserInput(prompt: "시험 범위의 세부 내용을 입력하세요:")

let examInfo = ExamInfo(
    subject: subject,
    chapter: chapter,
    subChapter: subChapter,
    examType: examType,
    detailedScope: detailedScope
)

let examManager = ExamManager(apiKey: apiKey, examInfo: examInfo)

print("\n문제 유형을 선택하세요:")
print("1. 객관식")
print("2. 주관식 단답형")
print("3. OX 문제")

if let choice = Int(getUserInput(prompt: "선택(1-3):")) {
    let questionType: QuestionType
    switch choice {
    case 1: questionType = .multipleChoice
    case 2: questionType = .shortAnswer
    case 3: questionType = .trueFalse
    default:
        print("잘못된 선택입니다.")
        exit(1)
    }
    
    print("\n문제를 생성중입니다...")
    examManager.generateQuestion(type: questionType) { result in
        switch result {
        case .success(let question):
            print("\n[문제]")
            print(question.content)
            
            // 객관식 문제 처리
            if question.type == .multipleChoice, let choices = question.choices {
                // 보기 출력
                for (index, choice) in choices.enumerated() {
                    print("\(index + 1)) \(choice)")
                }
                
                // 사용자 답 입력
                let userAnswer = getUserInput(prompt: "답을 입력하세요(1-4):")
                print("\n[정답] \(question.correctAnswer)")
                
                // 각 보기에 대한 해설
                print("\n[보기별 해설]")
                for (index, choice) in choices.enumerated() {
                    print("\n\(index + 1)) \(choice)")
                    if (index + 1).description == question.correctAnswer {
                        print("✅ 정답: \(question.explanation ?? "해설 없음")")
                    } else {
                        // OpenAI에게 오답 해설 요청
                        print("❌ \(examInfo.subject) \(examInfo.chapter)의 관점에서 이 보기가 오답인 이유를 설명합니다.")
                    }
                }
                
                // 정답 체크
                if userAnswer == question.correctAnswer {
                    print("\n✅ 정답입니다!")
                } else {
                    print("\n❌ 틀렸습니다. 정답은 \(question.correctAnswer)번 입니다.")
                }
            }
            // 주관식/OX 문제 처리
            else {
                let userAnswer = getUserInput(prompt: "답을 입력하세요:")
                print("\n[정답] \(question.correctAnswer)")
                if let explanation = question.explanation {
                    print("\n[해설]\n\(explanation)")
                }
                
                if userAnswer.lowercased() == question.correctAnswer.lowercased() {
                    print("\n✅ 정답입니다!")
                } else {
                    print("\n❌ 틀렸습니다.")
                }
            }
            
        case .failure(let error):
            print("오류 발생: \(error.localizedDescription)")
        }
        exit(0)
    }
    
    RunLoop.main.run()
}
