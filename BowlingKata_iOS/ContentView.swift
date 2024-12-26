//
//  ContentView.swift
//  BowlingKata_iOS
//
//  Created by Ricky Munz on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Grid(horizontalSpacing: 0) {
                GridRow {
                    ForEach(0..<10) { _ in
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

                                Spacer()
                                Spacer()
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .scaledToFill()
                        .gridCellUnsizedAxes(.vertical)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
