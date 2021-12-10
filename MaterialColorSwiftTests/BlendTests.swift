//
//  MaterialColorSwiftTests.swift
//  MaterialColorSwiftTests
//
//  Created by 坂本　尚嗣 on 2021/12/11.
//

import XCTest
@testable import MaterialColorSwift


private let red = 0xffff0000
private let blue = 0xff0000ff
private let green = 0xff00ff00
private let yellow = 0xffffff00

class BlendTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testRedToBlue() {
        let answer = Blend.harmonize(designColor: red, sourceColor: blue)
        XCTAssertEqual(answer, 0xffFB0054)
    }
    func testRedToGreen() {
        let answer = Blend.harmonize(designColor: red, sourceColor: green);
        XCTAssertEqual(answer, 0xffDA5400)
    }
    
    func testRedToYellow() {
        let answer = Blend.harmonize(designColor: red, sourceColor: yellow);
        XCTAssertEqual(answer, 0xffDA5400)
    }
    
    func testBlueToGreen() {
        let answer = Blend.harmonize(designColor: blue, sourceColor: green);
        XCTAssertEqual(answer, 0xff0047A7)
    }
    
    func testBlueToRed() {
        let answer = Blend.harmonize(designColor: blue, sourceColor: red)
        XCTAssertEqual(answer, 0xff5600DF)
    }
    
    func testBlueToYellow() {
        let answer = Blend.harmonize(designColor: blue, sourceColor: yellow)
        XCTAssertEqual(answer, 0xff0047A7)
    }
    
    func testGreenToBlue() {
        let answer = Blend.harmonize(designColor: green, sourceColor: blue)
        XCTAssertEqual(answer, 0xff00FC91)
    }

    func testgreenToRed() {
        let answer = Blend.harmonize(designColor: green, sourceColor: red)
        XCTAssertEqual(answer, 0xffADF000)
    }
    
    func testgreenToYellow() {
        let answer = Blend.harmonize(designColor: green, sourceColor: yellow)
        XCTAssertEqual(answer, 0xffADF000)
    }
    
    func testyellowToBlue() {
        let answer = Blend.harmonize(designColor: yellow, sourceColor: blue)
        XCTAssertEqual(answer, 0xffEBFFB2)
    }
    
    func testyellowToGreen() {
        let answer = Blend.harmonize(designColor: yellow, sourceColor: green)
        XCTAssertEqual(answer, 0xffEBFFB2)
    }
    
    func testyellowToRed() {
        let answer = Blend.harmonize(designColor: yellow, sourceColor: red)
        XCTAssertEqual(answer, 0xffFFF6DC)
    }
}
