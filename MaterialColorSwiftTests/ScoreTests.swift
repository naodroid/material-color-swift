//
//  ScoreTests.swift
//  MaterialColorSwiftTests
//
//  Created by nao on 2021/12/12.
//

import XCTest
@testable import MaterialColorSwift

class ScoreTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    func testPrioritizesChromaWhenProportionsEqual() {
        let colorsToPopulation: [Int: Int] = [
            0xffff0000: 1,
            0xff00ff00: 1,
            0xff0000ff: 1
        ]
        let ranked = Score.score(colorsToPopulation: colorsToPopulation)
        
        XCTAssertEqual(ranked[0], 0xffff0000)
        XCTAssertEqual(ranked[1], 0xff00ff00)
        XCTAssertEqual(ranked[2], 0xff0000ff)
    }
    
    func testGeneratesGBlueWhenNoColorsAvailable() {
        let colorsToPopulation: [Int: Int] = [0xff000000: 1]
        let ranked = Score.score(colorsToPopulation: colorsToPopulation);
        
        XCTAssertEqual(ranked[0], 0xff4285F4)
    }
    
    func testDedupesNearbyHues() {
        let colorsToPopulation: [Int: Int] = [
            0xff008772: 1, // H 180 C 42 T 50
            0xff318477: 1 // H 184 C 35 T 50
        ]
        let ranked = Score.score(colorsToPopulation: colorsToPopulation)
        
        XCTAssertEqual(ranked.count, 1)
        XCTAssertEqual(ranked[0], 0xff008772)
    }
    
}
