//
//  ContentView.swift
//  BowlingKata_iOS
//
//  Created by Ricky Munz on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var pins: String = ""
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Grid(horizontalSpacing: 0) {
                GridRow {
                    ForEach(viewModel.frameScores, id: \.self) { score in
                        ZStack {
                            Color(.clear)
                                .border(.black)

                            VStack {
                                HStack(spacing: 0) {
                                    ForEach(0..<3) { _ in
                                        Color(.clear)
                                            .border(.black)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                Text(score)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .scaledToFill()
                        .gridCellUnsizedAxes(.vertical)
                    }
                }
            }
            .padding()

            HStack {
                Text("Pins:")

                TextField(text: $pins) {}
                .textFieldStyle(.roundedBorder)
                .fixedSize()
            }
            .padding(.horizontal)

            Button {
                guard let pinsInt = Int(pins) else {
                    return
                }
                viewModel.roll(pinsInt)
            } label: {
                Text("Roll")
            }
        }
    }
}

#Preview {
    ContentView()
}
