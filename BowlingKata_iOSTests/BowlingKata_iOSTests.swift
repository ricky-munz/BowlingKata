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
    
    @Test func viewModel_onInit_finalFrameIndexIsNine() {
        let sut = ViewModel()
        
        #expect(sut.finalFrameIndex == 9)
    }
    
    @Test func viewModel_rollZero_rollScoreIsZero() {
        var sut = ViewModel()
        
        sut.roll(0)
        
        #expect(sut.frameScore == nil)
        #expect(sut.rollScores == [0])
    }
    
    @Test func viewModel_rollTwoZeros_frameScoreIsZero() {
        var sut = ViewModel()
        
        sut.roll(0)
        sut.roll(0)
        
        #expect(sut.frameScore == 0)
        #expect(sut.rollScores == [0, 0])
    }

    @Test func viewModel_rollOne_rollScoreIsOne() {
        var sut = ViewModel()
        
        sut.roll(1)
        
        #expect(sut.frameScore == nil)
        #expect(sut.rollScores == [1])
    }

    @Test func viewModel_rollTwoOnes_frameScoreIsTwo() {
        var sut = ViewModel()
        
        sut.roll(1)
        sut.roll(1)

        #expect(sut.frameScore == 2)
        #expect(sut.rollScores == [1, 1])
    }
}
