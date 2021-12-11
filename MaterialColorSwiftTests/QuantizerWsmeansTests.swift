//
//  QuantizerWsmeansTests.swift
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

class QuantizerWumeansTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func test1Rando() {
        let result = QuantizerWsmeans.quantize(inputPixels: [0xff141216],
                                               maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
      XCTAssertEqual(colors[0], 0xff141216)
    }

    func test1R() {
        let result = QuantizerWsmeans.quantize(inputPixels: [red],
                                               maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
    }
    func test1R_2() {
        let result = QuantizerWsmeans.quantize(inputPixels: [red],
                                               maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
      XCTAssertEqual(colors[0], red)
    }
    func test1G() {
        let result = QuantizerWsmeans.quantize(inputPixels: [green],
                                               maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
      XCTAssertEqual(colors[0], green)
    }
    func test1B() {
        let result = QuantizerWsmeans.quantize(inputPixels: [blue],
                                               maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
      XCTAssertEqual(colors[0], blue)
    }

    func test5B() {
      let result = QuantizerWsmeans.quantize(
        inputPixels: [blue, blue, blue, blue, blue], maxColors: maxColors);
      let colors = Array(result.colorToCount.keys)
      XCTAssertEqual(colors.count, 1)
      XCTAssertEqual(colors[0], blue)
    }
}

