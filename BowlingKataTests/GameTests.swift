//
//  GameTests.swift
//  BowlingKataTests
//
//  Created by Ricky Munz on 11/22/24.
//

import XCTest
@testable import BowlingKata

final class GameTests: XCTestCase {
    func testGutterGame() {
        let game = Game()
        for _ in 1...20 {
            game.roll(0)
        }
        XCTAssertEqual(game.score(), 0)
    }

    func testAllOnes() {
        let game = Game()
        for _ in 1...20 {
            game.roll(1)
        }
        XCTAssertEqual(game.score(), 20)
    }
}
