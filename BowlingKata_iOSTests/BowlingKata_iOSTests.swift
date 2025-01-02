//
//  BowlingKata_iOSTests.swift
//  BowlingKata_iOSTests
//
//  Created by Ricky Munz on 12/12/24.
//

import Testing
@testable import BowlingKata_iOS

struct BowlingKata_iOSTests {
    
    @Test func viewModel_onInit_hasTenFrames() {
        let sut = ViewModel()
        #expect(sut.framesCount == 10)
    }
}
