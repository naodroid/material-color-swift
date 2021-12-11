//
//  QuantizerWuTests.swift
//  MaterialColorSwiftTests
//
//  Created by nao on 2021/12/12.
//

import XCTest
@testable import MaterialColorSwift


private let red = 0xffff0000
private let green = 0xff00ff00
private let blue = 0xff0000ff
private let white = 0xffffffff
private let random = 0xff426088
private let maxColors = 256

class QuantizerWuTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func test1R() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [red], maxColors: maxColors)
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
    }
    func test1Rando() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [0xff141216], maxColors: maxColors);
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(colors[0], 0xff141216)
    }
    func test1R_2() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [red], maxColors: maxColors);
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(colors[0], red)
    }
    func test1G() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [green], maxColors: maxColors);
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(colors[0], green)
    }
    func test1B() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [blue], maxColors: maxColors);
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(colors[0], blue)
    }
    
    func test5B() async {
        let wu = QuantizerWu();
        let result =
        await wu.quantize(pixels: [blue, blue, blue, blue, blue], maxColors: maxColors);
        let colors = Array(result.colorToCount.keys)
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(colors[0], blue)
    }
    
    func test2R3G() async {
        let wu = QuantizerWu();
        let result =
        await wu.quantize(pixels: [red, red, green, green, green],
                          maxColors: maxColors);
        let colors = Array(result.colorToCount.keys).sorted()
        XCTAssertEqual(colors.count, 2)
        XCTAssertEqual(colors[0], green)
        XCTAssertEqual(colors[1], red)
    }
    
    func test1R1G1B() async {
        let wu = QuantizerWu()
        let result = await wu.quantize(pixels: [red, green, blue],
                                       maxColors: maxColors);
        let colors = Array(result.colorToCount.keys).sorted()
        XCTAssertEqual(colors.count, 3)
        XCTAssertEqual(colors[0], blue)
        XCTAssertEqual(colors[1], green)
        XCTAssertEqual(colors[2], red)
    }
}
