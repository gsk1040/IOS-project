import SwiftUI

struct ElectricianQuizView: View {
    @State private var questions = [
        Question(
            text: "전기 회로에서 전압, 전류, 저항의 관계를 나타내는 법칙은?",
            options: ["옴의 법칙", "패러데이 법칙", "키르히호프 법칙", "렌츠의 법칙"],
            correctAnswer: 0),
        Question(
            text: "교류(AC)를 직류(DC)로 변환하는 장치는?",
            options: ["정류기", "변압기", "인버터", "컨버터"],
            correctAnswer: 0),
        Question(
            text: "접지의 주요 목적은?",
            options: ["과전압 방지", "누전 방지", "감전 사고 예방", "이 모든 것"],
            correctAnswer: 3),
    ]

    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingScore = false

    var body: some View {
        VStack(spacing: 20) {
            Text("전기기사 문제 퀴즈")
                .font(.title)
                .fontWeight(.bold)

            if currentQuestionIndex < questions.count {
                QuestionView(question: questions[currentQuestionIndex]) { selectedAnswer in
                    checkAnswer(selectedAnswer)
                }
            }

            Text("문제 \(currentQuestionIndex + 1)/\(questions.count)")
                .foregroundColor(.gray)
        }
        .padding()
        .alert("퀴즈 완료!", isPresented: $showingScore) {
            Button("다시 시작", action: resetQuiz)
        } message: {
            Text("총점: \(score)점")
        }
    }

    private func checkAnswer(_ selectedAnswer: Int) {
        if selectedAnswer == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }

        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            showingScore = true
        }
    }

    private func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
    }
}

struct Question {
    let text: String
    let options: [String]
    let correctAnswer: Int
}

struct QuestionView: View {
    let question: Question
    let answerSelected: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(question.text)
                .font(.headline)
                .padding(.bottom)

            ForEach(0..<question.options.count, id: \.self) { index in
                Button(action: {
                    answerSelected(index)
                }) {
                    Text(question.options[index])
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

// 미리보기
struct ElectricianQuizView_Previews: PreviewProvider {
    static var previews: some View {
        ElectricianQuizView()
    }
}
