//
//  HctTests.swift
//  MaterialColorSwiftTests
//
//  Created by 坂本　尚嗣 on 2021/12/11.
//

import XCTest
@testable import MaterialColorSwift


private let black = 0xff000000
private let white = 0xffffffff
private let red = 0xffff0000
private let green = 0xff00ff00
private let blue = 0xff0000ff
private let midgray = 0xff777777


class HctTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testConversionsAreReflexive() {
        let cam = Cam16.fromInt(argb: red);
        let color = cam.viewed(viewingConditions: ViewingConditions.standard)
        XCTAssertEqual(color, red)
    }
    
    func testYMidgray() {
        XCTAssertEqual(18.418, ColorUtils.yFrom(lstar: 50.0), accuracy: 0.001)
    }
    
    func testYBlack() {
        XCTAssertEqual(0.0, ColorUtils.yFrom(lstar: 0.0), accuracy: 0.001)
    }
    
    func testYWhite() {
        XCTAssertEqual(100.0, ColorUtils.yFrom(lstar: 100.0), accuracy: 0.001)
    }
    
    func testCamRed() {
        let cam = Cam16.fromInt(argb: red)
        XCTAssertEqual(46.445, cam.j, accuracy: 0.001)
        XCTAssertEqual(113.357, cam.chroma, accuracy: 0.001)
        XCTAssertEqual(27.408, cam.hue, accuracy: 0.001)
        XCTAssertEqual(89.494, cam.m, accuracy: 0.001)
        XCTAssertEqual(91.889, cam.s, accuracy: 0.001)
        XCTAssertEqual(105.988, cam.q, accuracy: 0.001)
    }
    
    func testCamGreen() {
        let cam = Cam16.fromInt(argb: green);
        XCTAssertEqual(79.331, cam.j, accuracy: 0.001)
        XCTAssertEqual(108.410, cam.chroma, accuracy: 0.001)
        XCTAssertEqual(142.139, cam.hue, accuracy: 0.001)
        XCTAssertEqual(85.587, cam.m, accuracy: 0.001)
        XCTAssertEqual(78.604, cam.s, accuracy: 0.001)
        XCTAssertEqual(138.520, cam.q, accuracy: 0.001)
    }
    
    func testCamBlue(){
        let cam = Cam16.fromInt(argb: blue)
        XCTAssertEqual(25.465, cam.j, accuracy: 0.001)
        XCTAssertEqual(87.230, cam.chroma, accuracy: 0.001)
        XCTAssertEqual(282.788, cam.hue, accuracy: 0.001)
        XCTAssertEqual(68.867, cam.m, accuracy: 0.001)
        XCTAssertEqual(93.674, cam.s, accuracy: 0.001)
        XCTAssertEqual(78.481, cam.q, accuracy: 0.001)
    }
    func testCamBlack() {
        let cam = Cam16.fromInt(argb: black)
        XCTAssertEqual(0.0, cam.j, accuracy: 0.001)
        XCTAssertEqual(0.0, cam.chroma, accuracy: 0.001)
        XCTAssertEqual(0.0, cam.hue, accuracy: 0.001)
        XCTAssertEqual(0.0, cam.m, accuracy: 0.001)
        XCTAssertEqual(0.0, cam.s, accuracy: 0.001)
        XCTAssertEqual(0.0, cam.q, accuracy: 0.001)
    }
    
    func testCamWhite() {
        let cam = Cam16.fromInt(argb: white)
        XCTAssertEqual(100.0, cam.j, accuracy: 0.001)
        XCTAssertEqual(2.869, cam.chroma, accuracy: 0.001)
        XCTAssertEqual(209.492, cam.hue, accuracy: 0.001)
        XCTAssertEqual(2.265, cam.m, accuracy: 0.001)
        XCTAssertEqual(12.068, cam.s, accuracy: 0.001)
        XCTAssertEqual(155.521, cam.q, accuracy: 0.001)
    }
    
    func testGamutMapRed() {
        let colorToTest = red;
        let cam = Cam16.fromInt(argb: colorToTest);
        let color = HctColor.from(hue: cam.hue,
                                  chroma: cam.chroma,
                                  tone: ColorUtils.lstarFrom(argb: colorToTest))
            .toInt();
        XCTAssertEqual(colorToTest, color)
    }
    
    func testGamutMapGreen() {
        let colorToTest = green;
        let cam = Cam16.fromInt(argb: colorToTest);
        let color = HctColor.from(hue: cam.hue,
                                  chroma: cam.chroma,
                                  tone: ColorUtils.lstarFrom(argb: colorToTest))
            .toInt()
        XCTAssertEqual(colorToTest, color)
    }
    
    func testGamutMapBlue() {
        let colorToTest = blue;
        let cam = Cam16.fromInt(argb: colorToTest);
        let color = HctColor.from(hue: cam.hue,
                                  chroma: cam.chroma,
                                  tone: ColorUtils.lstarFrom(argb: colorToTest))
            .toInt()
        XCTAssertEqual(colorToTest, color)
    }
    
    func testGamutMapWhite() {
        let colorToTest = white;
        let cam = Cam16.fromInt(argb: colorToTest)
        let color = HctColor.from(hue: cam.hue,
                                  chroma: cam.chroma,
                                  tone: ColorUtils.lstarFrom(argb: colorToTest))
            .toInt()
        XCTAssertEqual(colorToTest, color)
    }
    
    func testGamutMapMidgray() {
        let colorToTest = green;
        let cam = Cam16.fromInt(argb: colorToTest);
        let color = HctColor.from(hue: cam.hue,
                                  chroma: cam.chroma,
                                  tone: ColorUtils.lstarFrom(argb: colorToTest))
            .toInt()
        XCTAssertEqual(colorToTest, color)
    }
}
