//
//  ContentView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 11.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var pickedNumber = 2
    
    @State var sheetShown = false
    
    let animals = ["cow", "bear", "chick", "giraffe", "narwhal", "rhino", "penguin", "parrot", "snake"]
    
    
    var body: some View {
        NavigationStack {
            // settings
                GeometryReader { geometry in
                    ScrollView {
                        ForEach(1...9, id: \.self) { number in
                            Button {
                                // action
                                pickedNumber = number
                                print("Setting pickedNumber to \(number), now it's \(pickedNumber)")
                            } label: {
                                VStack {
                                    Image(animals[number - 1])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 70)
                                    Text("Multiply by \(number)")
                                        .foregroundStyle(Color("textColor"))
                                }
                            }
                            .offset(CGSize(width: imagePos(number: number), height: 0.0))
                            .frame(width: geometry.size.width)
                        }
                    }
                }
                .onChange(of: pickedNumber, initial: false) { oldValue, newValue in
                    if newValue != oldValue {
                        // Use DispatchQueue to ensure that the sheet is presented after the state update
                        DispatchQueue.main.async {
                            sheetShown = false // Reset sheetShown to prevent infinite loop
                            sheetShown = true
                        }
                    }
                }
                Spacer()
                .buttonStyle(.borderedProminent)
                .navigationBarBackButtonHidden(true)
                .navigationTitle("MultiplyLab")
                .sheet(isPresented: $sheetShown) {
                    ContentSheetView(pickedNumber: pickedNumber)
                }
        }
    }
    
    func imagePos(number: Int) -> Double {
        switch number {
        case 1, 5, 9:
            return -100.0
        case 2, 4, 6, 8:
            return 0.0
        case 3, 7:
            return 100.0
        default:
            return 0.0
        }
    }
    
}

struct ContentSheetView: View {
    
    @State var pickedNumber: Int
    
    @State private var questionAmount = 1
    
    var body: some View {
        NavigationStack {
            Spacer()
            Image(ContentView().animals[pickedNumber - 1])
            Text("You picked \(pickedNumber)!")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
            VStack {
                Text("How many questions would you like?")
                Text("Pick a number of questions: \(questionAmount)")
            }
            .font(.system(size: 20, weight: .light, design: .rounded))
            .padding()
            HStack {
                ForEach(1...9, id: \.self) { number in
                    Button {
                        questionAmount = number
                    } label: {
                        Image(systemName: "\(number).circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(number <= 3 ? .green : number <= 6 ? .orange : .red)
                    }
                }
            }
            Spacer()
            NavigationLink {
                GameView(questionAmount: questionAmount, pickedNumber: pickedNumber)
            } label: {
                Text("Start!")
                    .frame(width: 200, height: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .presentationBackground(.ultraThinMaterial)
    }
}

#Preview {
    ContentView()
}
