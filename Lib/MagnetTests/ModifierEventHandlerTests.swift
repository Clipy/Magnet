// 
//  ModifierEventHandlerTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import XCTest
@testable import Magnet

// swiftlint:disable xctfail_message
final class ModifierEventHandlerTests: XCTestCase {

    private let testTimeInterval = DispatchTimeInterval.milliseconds(100)
    private let testQueue = DispatchQueue(label: "com.clipy-app.Magnet")

    // MARK: - Tests
    func testDoubleTapModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        let expectation = XCTestExpectation(description: "Shift double tapped")
        eventHandler.doubleTapped = { tappedModifierFlags in
            XCTAssertEqual(tappedModifierFlags, [.shift])
            expectation.fulfill()
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 2)
        wait(for: [expectation], timeout: 1)
    }

    func testFilterHandledTimestampModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        eventHandler.doubleTapped = { tappedModifierFlags in
            XCTFail()
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
    }

    func testFilerUnsupportModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        eventHandler.doubleTapped = { tappedModifierFlags in
            XCTFail()
        }
        eventHandler.handleModifiersEvent(with: [.function], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.function], timestamp: 2)
    }

    func testMultiModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        let expectation = XCTestExpectation(description: "Shift double tapped")
        var isFirstCalled = false
        eventHandler.doubleTapped = { tappedModifierFlags in
            if isFirstCalled {
                XCTFail()
            } else {
                XCTAssertEqual(tappedModifierFlags, [.shift])
                isFirstCalled = true
            }
            expectation.fulfill()
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.control], timestamp: 2)
        eventHandler.handleModifiersEvent(with: [], timestamp: 3)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 4)
        eventHandler.handleModifiersEvent(with: [], timestamp: 5)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 6)
        wait(for: [expectation], timeout: 1)
    }

    func testSimultaneouslyPressMultiModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        let expectation = XCTestExpectation(description: "Shift double tapped")
        var isFirstCalled = false
        eventHandler.doubleTapped = { tappedModifierFlags in
            if isFirstCalled {
                XCTFail()
            } else {
                XCTAssertEqual(tappedModifierFlags, [.shift])
                isFirstCalled = true
            }
            expectation.fulfill()
        }
        eventHandler.handleModifiersEvent(with: [.shift, .control], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [], timestamp: 2)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 3)
        eventHandler.handleModifiersEvent(with: [], timestamp: 4)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 5)
        wait(for: [expectation], timeout: 1)
    }

    func testNoCleanModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanTimeInterval: testTimeInterval, cleanQueue: testQueue)
        let expectation = XCTestExpectation(description: "Shift double tapped")
        eventHandler.doubleTapped = { tappedModifierFlags in
            XCTAssertEqual(tappedModifierFlags, [.shift])
            expectation.fulfill()
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        testQueue.asyncAfter(deadline: .now() + testTimeInterval - .milliseconds(1)) {
            eventHandler.handleModifiersEvent(with: [.shift], timestamp: 2)
        }
        wait(for: [expectation], timeout: 1)
    }

    func testCleanModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanTimeInterval: testTimeInterval, cleanQueue: testQueue)
        let expectation = XCTestExpectation(description: "Shift double tapped")
        eventHandler.doubleTapped = { tappedModifierFlags in
            XCTFail()
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        testQueue.asyncAfter(deadline: .now() + testTimeInterval + .milliseconds(1)) {
            eventHandler.handleModifiersEvent(with: [.shift], timestamp: 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
