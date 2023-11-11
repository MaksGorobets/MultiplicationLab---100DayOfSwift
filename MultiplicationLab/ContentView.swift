//
//  ContentView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 11.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    @State private var isActive = false
    
    @State private var questionAmount = 0
    @State private var questionCount = 0
    
    @State private var number = 0
    @State private var currentQuestion = ""
    
    @State private var rightAnswer = 0
    @State private var playersAnswer = 0
    @State private var selectedButton = 5 // used for button coloring
    
    @State private var buttonArray = ["0", "0", "0", "0"]
    
    @State private var ranButtonIndex = Int.random(in: 0...3)
    
    @State private var questions = [Array<Question>]()
    @State private var usedQuestions = Set<Int>()
    
    @State private var alertIsShown = false
    
    var body: some View {
        if isActive {
            // game
            HStack {
                Text("Question \(questionCount) out of \(questionAmount)")
                Text("Score: \(score)")
            }
            Spacer()
            Text(currentQuestion)
                .font(.system(size: 50))
            HStack {
                ForEach(0..<4) { index in
                    let bText = buttonArray[index]
                    Button(bText) {
                        selectedButton = index
                        playersAnswer = Int(bText) ?? 0
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(selectedButton == index ? Color.red : Color.blue)
                }
            }
            Spacer()
            Button("Next") {
                selectedButton = 5
                questionCount += 1
                checkAnswer()
                showQuestion()
                playersAnswer = 0
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .disabled(alertIsShown)
            .alert("Game ended", isPresented: $alertIsShown) {
                Button("OK") {
                    isActive = false
                }
            } message: {
                Text("You did great!")
            }
        } else {
            // settings
            Stepper("Pick a number: \(number)", value: $number, in: 2...9)
                .padding()
            Stepper("Pick a number of questions: \(questionAmount)", value: $questionAmount, in: 1...10)
                .padding()
            Button("Play!") {
                generateQuestions()
                isActive = true
                showQuestion()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func buttonText() { // randomizing wrong buttons if it's not ranButtonIndex
        for index in 0...3 {
            if index <= 1 {
                buttonArray[index] = index == ranButtonIndex ? "\(rightAnswer)" : "\(rightAnswer + number + index)"
            } else {
                buttonArray[index] = index == ranButtonIndex ? "\(rightAnswer)" : "\(rightAnswer - number - index)"
            }
        }
    }
    
    func checkAnswer() {
        if questionCount >= questionAmount {
            alertIsShown = true
        }
        if playersAnswer == rightAnswer {
            score += 50
            print("Adding score")
        }
    }
    
    func generateQuestions() {
        usedQuestions.removeAll()
        for _ in 0...questionAmount { // generate set amount of questions
            var rand: Int // random multiplier
            repeat {
                rand = Int.random(in: 1..<10)
            } while usedQuestions.contains(rand)
            usedQuestions.insert(rand)
            questions.append([Question(text: "\(number) x \(rand)", answer: number * rand)]) // adding questions one by one
        }
    }
    func showQuestion() {
        ranButtonIndex = Int.random(in: 0...3) // which button will contain the right answer
        print(ranButtonIndex)
        let randomQuestion = questions[questionCount] // they are generated randomly anyways, so picking one with question count doesn't affect anything
        
        currentQuestion = randomQuestion[0].text // extract question
        rightAnswer = randomQuestion[0].answer //extract right answer
        buttonText()
    }
}

struct Question {
    var text: String
    var answer: Int
}

#Preview {
    ContentView()
}
