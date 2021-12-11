//
//  SchemeTests.swift
//  MaterialColorSwiftTests
//
//  Created by nao on 2021/12/12.
//

import XCTest
@testable import MaterialColorSwift

class SchemeTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testblueLightScheme() {
        let scheme = Scheme.light(color: 0xff0000ff)
      XCTAssertEqual(scheme.primary, 0xff333CFF)
    }

    func testBlueDarkScheme() {
      let scheme = Scheme.dark(color: 0xff0000ff)
      XCTAssertEqual(scheme.primary, 0xffBDC2FF)
    }

    func test3rdPartyLightScheme() {
      let scheme = Scheme.light(color: 0xff6750A4)
      XCTAssertEqual(scheme.primary, 0xff6750A4)
      XCTAssertEqual(scheme.secondary, 0xff625B71)
      XCTAssertEqual(scheme.tertiary, 0xff7D5260)
      XCTAssertEqual(scheme.surface, 0xfffffbfe)
      XCTAssertEqual(scheme.onSurface, 0xff1C1B1E)
    }

    func test3rdPartyDarkScheme() {
      let scheme = Scheme.dark(color: 0xff6750A4)
      XCTAssertEqual(scheme.primary, 0xffd0bcff)
      XCTAssertEqual(scheme.secondary, 0xffCBC2DB)
      XCTAssertEqual(scheme.tertiary, 0xffEFB8C8)
      XCTAssertEqual(scheme.surface, 0xff1c1b1e)
      XCTAssertEqual(scheme.onSurface, 0xffE6E1E5)
    }
}
