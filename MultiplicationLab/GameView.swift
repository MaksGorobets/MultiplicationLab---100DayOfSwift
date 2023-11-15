//
//  GameView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 13.11.2023.
//

import SwiftUI

struct GameView: View {
    
    @State private var score = 0
    
    @State var questionAmount: Int
    @State private var questionCount = 1
    
    @State private var rightAnswer = 0
    @State private var playersAnswer = 0
    
    @State var pickedNumber: Int
    @State private var currentQuestion = ""
    
    @State private var selectedButton = 5 // used for button coloring
    @State private var buttonArray = ["0", "0", "0", "0"]
    @State private var ranButtonIndex = Int.random(in: 0...3)
    
    @State private var questions = [Array<Question>]()
    @State private var usedQuestions = Set<Int>()
    
    @State private var alertIsShown = false
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Question \(questionCount) out of \(questionAmount)")
                Text("Score: \(score)")
            }
            ProgressBarView(progress: Double(questionCount), total: Double(questionAmount))
                .frame(height: 10)
            Spacer()
            Text(currentQuestion)
                .font(.system(size: 50))
            HStack {
                ForEach(0..<4) { index in
                    let bText = buttonArray[index]
                    Button(bText) {
                        withAnimation(.easeIn) {
                            selectedButton = index
                        }
                        playersAnswer = Int(bText) ?? 0
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(selectedButton == index ? Color.red : Color.blue)
                }
            }
            Spacer()
            Button("Next") {
                withAnimation(.bouncy) {
                    checkAnswer()
                    selectedButton = 5
                    showQuestion()
                    playersAnswer = 0
                }
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .disabled(alertIsShown)
            .alert("Game ended", isPresented: $alertIsShown) {
                Button("OK") {
                }
            } message: {
                isResultGood()
            }
            .onAppear {
                    generateQuestions()
                    showQuestion()
            }
        }
    }
    
    func isResultGood() -> Text {
        let maxScore = questionAmount * 50
        let halfMaxScore = maxScore / 2
        return Text(score >= halfMaxScore ? "You did great!" : "You did good, keep practicing!")
    }
    
    func checkAnswer() {
        if questionCount >= questionAmount {
            alertIsShown = true
        } else { questionCount += 1 }
        if playersAnswer == rightAnswer {
            score += 50
        }
    }
    
    func generateQuestions() {
        usedQuestions.removeAll()
        for _ in 0..<questionAmount { // generate set amount of questions
            var rand: Int // random multiplier
            
            repeat {
                rand = Int.random(in: 1..<10)
                print("Looping...")
            } while usedQuestions.contains(rand)
            
            usedQuestions.insert(rand)
            questions.append([Question(text: "\(pickedNumber) x \(rand)", answer: pickedNumber * rand)]) // adding questions one by one
        }
        print("Generated \(questions.count)")
    }
    func showQuestion() {
        ranButtonIndex = Int.random(in: 0...3) // which button will contain the right answer
        print(questions)
        print("Question amount: \(questions.count), question number: \(questionCount)")
        let randomQuestion = questions[questionCount - 1] // they are generated randomly anyways, so picking one with question count doesn't affect anything
        print("Picked a random question: \(randomQuestion)")
        
        currentQuestion = randomQuestion[0].text // extract question
        rightAnswer = randomQuestion[0].answer //extract right answer
        buttonText()
    }
    
    func buttonText() { // randomizing wrong buttons if it's not ranButtonIndex
        for index in 0...3 {
            
            let addedButton = rightAnswer + pickedNumber + index
            let subtractedButton = rightAnswer - pickedNumber - index
            
            if index <= 1 {
                buttonArray[index] = index == ranButtonIndex ? "\(rightAnswer)" : "\(addedButton)"
            } else {
                buttonArray[index] = index == ranButtonIndex ? "\(rightAnswer)" : "\(subtractedButton <= 0 ? addedButton : subtractedButton)"
            }
            
        }
    }
}

struct Question {
    var text: String
    var answer: Int
}

#Preview {
    GameView(questionAmount: 5, pickedNumber: 2)
}
