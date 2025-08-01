//
//  ContentView.swift
//  BowlingKata_iOS
//
//  Created by Ricky Munz on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Button {
                viewModel.isResetPresented = true
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }

            Grid(horizontalSpacing: 0) {
                GridRow {
                    ForEach(Array(viewModel.frameScores.enumerated()), id: \.offset) { frameIndex, score in
                        ZStack {
                            Color(.clear)
                                .border(.black)

                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    let numRolls = frameIndex == 9 ? 3 : 2
                                    if numRolls == 2 {
                                        Color(.clear)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    ForEach(0..<numRolls, id: \.self) { rollIndex in
                                        ZStack {
                                            Color(.clear)
                                                .border(.black)
                                                .aspectRatio(contentMode: .fit)
                                            
                                            if viewModel.rollScores.count < frameIndex * 2 + rollIndex + 1 {
                                                Text("")
                                            } else {
                                                Text(viewModel.rollScores[frameIndex * 2 + rollIndex])
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                Text(score)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                    .padding(.leading)
                                    .padding(.bottom)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .aspectRatio(1, contentMode: .fill)
                    }
                }
                .frame(maxHeight: 100)
            }
            .frame(maxWidth: .infinity)
            .padding()

            HStack {
                Text("Pins:")

                TextField(text: $viewModel.pins) {}
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .fixedSize()
            }
            .padding(.horizontal)

            Button {
                viewModel.roll()
            } label: {
                Text("Roll")
            }
            .disabled(viewModel.isGameCompleted)
        }
        .alert("Game over", isPresented: $viewModel.isGameCompleted) {
            Button("Play Again", role: .destructive) {
                viewModel.reset()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Reset?", isPresented: $viewModel.isResetPresented) {
            Button("OK", role: .destructive) {
                viewModel.reset()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Invalid Input", isPresented: $viewModel.isRollInvalid) {
            Button("OK") {}
        }
    }
}

#Preview {
    ContentView()
}
