// 
//  CollectionExtensionTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import XCTest
@testable import Magnet

final class CollectionExtensionTests: XCTestCase {

    // MARK: - Tests
    func testTrueCount() {
        XCTAssertEqual([Bool]().trueCount, 0)
        XCTAssertEqual([true].trueCount, 1)
        XCTAssertEqual([false].trueCount, 0)
        XCTAssertEqual([true, true].trueCount, 2)
        XCTAssertEqual([true, false].trueCount, 1)
        XCTAssertEqual([false, false].trueCount, 0)
        XCTAssertEqual([false, true, false, true].trueCount, 2)
    }

}
