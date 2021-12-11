//
//  PaletteTests.swift
//  MaterialColorSwiftTests
//
//  Created by 坂本　尚嗣 on 2021/12/11.
//

import XCTest
@testable import MaterialColorSwift


class PaletteTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
}

// MARK: group('[.of constructor]')
extension PaletteTests {
    func testTonesOfBlue() {
        let hct = HctColor.fromInt(argb: 0xff0000ff);
        let tones = TonalPalette.of(hue: hct.hue, chroma: hct.chroma);
        
        XCTAssertEqual(tones.getTone(0), 0xff000000)
        XCTAssertEqual(tones.getTone(10), 0xff00006f)
        XCTAssertEqual(tones.getTone(20), 0xff0000ad)
        XCTAssertEqual(tones.getTone(30), 0xff0000f0)
        XCTAssertEqual(tones.getTone(40), 0xff333cff)
        XCTAssertEqual(tones.getTone(50), 0xff5964ff)
        XCTAssertEqual(tones.getTone(60), 0xff7a85ff)
        XCTAssertEqual(tones.getTone(70), 0xff9ca4ff)
        XCTAssertEqual(tones.getTone(80), 0xffbdc2ff)
        XCTAssertEqual(tones.getTone(90), 0xffdfe0ff)
        XCTAssertEqual(tones.getTone(95), 0xfff0efff)
        XCTAssertEqual(tones.getTone(99), 0xfffefbff)
        XCTAssertEqual(tones.getTone(100), 0xffffffff)
        
        /// Tone not in [TonalPalette.commonTones]
        XCTAssertEqual(tones.getTone(3), 0xff00003e)
    }
    
    func testasList() {
        let hct = HctColor.fromInt(argb: 0xff0000ff);
        let tones = TonalPalette.of(hue: hct.hue, chroma: hct.chroma);
        
        XCTAssertEqual(tones.asList, [
            0xff000000,
            0xff00006f,
            0xff0000ad,
            0xff0000f0,
            0xff333cff,
            0xff5964ff,
            0xff7a85ff,
            0xff9ca4ff,
            0xffbdc2ff,
            0xffdfe0ff,
            0xfff0efff,
            0xfffefbff,
            0xffffffff,
        ])
    }
    
    func testOperatorAndashCode() {
        let hctAB = HctColor.fromInt(argb: 0xff0000ff);
        let tonesA = TonalPalette.of(hue: hctAB.hue, chroma: hctAB.chroma);
        let tonesB = TonalPalette.of(hue: hctAB.hue, chroma: hctAB.chroma);
        let hctC = HctColor.fromInt(argb: 0xff123456);
        let tonesC = TonalPalette.of(hue: hctC.hue, chroma: hctC.chroma);
        
        XCTAssertEqual(tonesA, tonesB);
        XCTAssertNotEqual(tonesB, tonesC)
        
        XCTAssertEqual(tonesA.hashValue, tonesB.hashValue);
        XCTAssertNotEqual(tonesB.hashValue, tonesC.hashValue)
    }
}


// MARK: group('[.fromList constructor]')
extension PaletteTests {
    func testTonesOfI() {
        let ints = (0..<TonalPalette.commonSize).map { $0 }
        let tones = TonalPalette.fromList(colors: ints)
        
        XCTAssertEqual(tones.getTone(100), 12);
        XCTAssertEqual(tones.getTone(99), 11);
        XCTAssertEqual(tones.getTone(95), 10);
        XCTAssertEqual(tones.getTone(90), 9);
        XCTAssertEqual(tones.getTone(80), 8);
        XCTAssertEqual(tones.getTone(70), 7);
        XCTAssertEqual(tones.getTone(60), 6);
        XCTAssertEqual(tones.getTone(50), 5);
        XCTAssertEqual(tones.getTone(40), 4);
        XCTAssertEqual(tones.getTone(30), 3);
        XCTAssertEqual(tones.getTone(20), 2);
        XCTAssertEqual(tones.getTone(10), 1);
        XCTAssertEqual(tones.getTone(0), 0);
        
        /// Tone not in [TonalPalette.commonTones]
        // TODO: XCTAssertThrowsError(tones.getTone(3))
        //(() => tones.getTone(3), throwsA(isA<ArgumentError>()));
    }
    
    func testAsList() {
        let ints = (0..<TonalPalette.commonSize).map { $0 }
        let tones = TonalPalette.fromList(colors: ints)
        XCTAssertEqual(tones.asList, ints)
    }
    
    func testOperatorEqualsAndHashCode() {
        let intsAB = (0..<TonalPalette.commonSize).map { $0 }
        let tonesA = TonalPalette.fromList(colors: intsAB)
        let tonesB = TonalPalette.fromList(colors: intsAB)
        let intsC = (0..<TonalPalette.commonSize).map { _ in 1 }
        let tonesC = TonalPalette.fromList(colors: intsC)
        
        XCTAssertEqual(tonesA, tonesB)
        XCTAssertNotEqual(tonesB, tonesC)
        
        XCTAssertEqual(tonesA.hashValue, tonesB.hashValue)
        XCTAssertNotEqual(tonesB.hashValue, tonesC.hashValue)
    }
}
// MARK: group('CorePalette')
extension PaletteTests {
    func testAsList2() {
        let ints = (0..<CorePalette.size * TonalPalette.commonSize).map { $0 }
        let corePalette = CorePalette.fromList(ints)
        XCTAssertEqual(corePalette.asList(), ints);
    }
    
    func testOperatorEqualsAndHashCode2() {
        let corePaletteA = CorePalette.of(argb: 0xff0000ff)
        let corePaletteB = CorePalette.of(argb: 0xff0000ff)
        let corePaletteC = CorePalette.of(argb: 0xff123456)
        
        XCTAssertEqual(corePaletteA, corePaletteB)
        XCTAssertNotEqual(corePaletteB, corePaletteC)
        
        XCTAssertEqual(corePaletteA.hashValue, corePaletteB.hashValue)
        XCTAssertNotEqual(corePaletteB.hashValue, corePaletteC.hashValue)
    }
}
