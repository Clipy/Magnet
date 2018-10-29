//
//  BoolTests.swift
//  MagnetTests
//
//  Created by 古林俊佑 on 2018/09/22.
//  Copyright © 2018年 Shunsuke Furubayashi. All rights reserved.
//

import XCTest
@testable import Magnet

final class BoolTests: XCTestCase {}

extension BoolTests {
    func testIntValue() {
        XCTAssertEqual(true.intValue, 1)
        XCTAssertEqual(false.intValue, 0)
    }
}
