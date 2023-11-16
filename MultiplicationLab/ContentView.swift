//
//  ContentView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 11.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var pickedNumber = 2 { didSet {
            sheetShown = false // Reset sheetShown to prevent infinite loop
            sheetShown = true
    }}
    
    @State var sheetShown = false
    
    @State var buttonAnimated = [false, false, false, false, false, false, false, false, false]
    
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
                                withAnimation {
                                    buttonAnimated[number - 1] = true
                                }
                                print("Setting pickedNumber to \(number), now it's \(pickedNumber)")
                            } label: {
                                VStack {
                                    Image(animals[number - 1])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 70)
                                        .scaleEffect(CGSize(width: buttonAnimated[number - 1] ? 1.2 : 1.0, height: buttonAnimated[number - 1] ? 1.2 : 1.0))
                                        .rotation3DEffect(
                                            Angle(degrees: buttonAnimated[number - 1] ? 360 : 0.0), axis: (x: 0.0, y: 1.0, z: 0.0)
                                        )
                                        .shadow(radius: 5)
                                    Text("Multiply by \(number)")
                                        .foregroundStyle(Color("textColor"))
                                }
                            }
                            .offset(CGSize(width: imagePos(number: number), height: 0.0))
                            .frame(width: geometry.size.width)
                        }
                    }
                }
                Spacer()
                .buttonStyle(.borderedProminent)
                .navigationBarBackButtonHidden(true)
                .navigationTitle("MultiplyLab")
                .sheet(isPresented: $sheetShown) {
                    ContentSheetView(pickedNumber: pickedNumber, sheetShown: $sheetShown, buttonAnimated: $buttonAnimated)
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
    
    @State private var imageRotation = 0.0
    
    @Binding var sheetShown: Bool
    @Binding var buttonAnimated: Array<Bool>
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Button(role: .destructive) {
                    sheetShown = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()
            Spacer()
            Image(ContentView().animals[pickedNumber - 1])
                .rotation3DEffect(
                    Angle(degrees: imageRotation), axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .onTapGesture {
                    withAnimation {
                        imageRotation += 360
                    }
                }
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
                GameView(questionAmount: questionAmount, pickedNumber: pickedNumber, sheetShown: $sheetShown)
            } label: {
                Text("Start!")
                    .frame(width: 200, height: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .presentationBackground(.ultraThinMaterial)
        .onDisappear {
            withAnimation {
                for index in 0..<buttonAnimated.count {
                    buttonAnimated[index] = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
