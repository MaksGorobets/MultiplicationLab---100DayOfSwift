//
//  TestView.swift
//  MultiplicationLab
//
//  Created by Maks Winters on 16.11.2023.
//

import SwiftUI

struct TestView: View {
    @State private var isSheetPresented = false

    var body: some View {
        VStack {
            Text("First View")
                .padding()
                .onTapGesture {
                    isSheetPresented.toggle()
                }
                .sheet(isPresented: $isSheetPresented) {
                    SecondView(isSheetPresented: $isSheetPresented)
                }
        }
    }
}

struct SecondView: View {
    @Binding var isSheetPresented: Bool
    @State private var isThirdSheetPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Second View")
                NavigationLink("Goto 3rd view") {
                    ThirdView(isSheetPresented: $isSheetPresented)
                }
                Button("Close sheet") {
                    isSheetPresented.toggle()
                }
            }
            .padding()
        }
    }
}

struct ThirdView: View {
    @Binding var isSheetPresented: Bool

    var body: some View {
        VStack {
            Text("Third View")
            Button("Close sheet") {
                isSheetPresented.toggle()
            }
        }
        .padding()
    }
}


#Preview {
    TestView()
}
