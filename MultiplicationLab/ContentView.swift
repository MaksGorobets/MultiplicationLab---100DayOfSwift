//
//  ContentView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 11.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var questionAmount = 1
    
    @State private var pickedNumber = 2
    
    
    var body: some View {
        NavigationStack {
            // settings
            Stepper("Pick a number: \(pickedNumber)", value: $pickedNumber, in: 2...9)
                .padding()
            Stepper("Pick a number of questions: \(questionAmount)", value: $questionAmount, in: 1...9)
                .padding()
            NavigationLink("Play!") {
                GameView(questionAmount: questionAmount, pickedNumber: pickedNumber)
            }
            .buttonStyle(.borderedProminent)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("MultiplyLab")
        }
    }

}

#Preview {
    ContentView()
}
