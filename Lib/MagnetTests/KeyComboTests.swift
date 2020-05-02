// 
//  KeyComboTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import XCTest
@testable import Magnet

final class KeyComboTests: XCTestCase {

    // MARK: - Tests
    func testFunctionInitializer() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        XCTAssertNotNil(keyCombo)
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift, .control, .command, .option])
        XCTAssertNotNil(keyCombo)
    }

    func testDoubledTapKeyComboInitializer() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertNotNil(keyCombo)
        keyCombo = KeyCombo(doubledCocoaModifiers: [])
        XCTAssertNil(keyCombo)
        keyCombo = KeyCombo(doubledCocoaModifiers: [.shift, .command])
        XCTAssertNil(keyCombo)
        keyCombo = KeyCombo(doubledCocoaModifiers: [.function])
        XCTAssertNil(keyCombo)
    }

    func testDoubledTapKeyComboCharacter() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertEqual(keyCombo?.characters, "")
        keyCombo = KeyCombo(doubledCocoaModifiers: .control)
        XCTAssertEqual(keyCombo?.characters, "")
        keyCombo = KeyCombo(doubledCocoaModifiers: .command)
        XCTAssertEqual(keyCombo?.characters, "")
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.characters, "")
    }

    func testCharacter() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.characters, "a")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.characters, "A")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.characters, "å")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.characters, "Å")
        keyCombo = KeyCombo(key: .one, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.characters, "1")
        keyCombo = KeyCombo(key: .semicolon, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.characters, "…")
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.characters, "F1")
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.characters, "")
    }

    func testKeyEquivalent() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalent, "a")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "A")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalent, "a")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "A")
        keyCombo = KeyCombo(key: .one, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "1")
        keyCombo = KeyCombo(key: .semicolon, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalent, ";")
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "F1")
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.keyEquivalent, "")
    }

    func testKeyEquivalentModifierMaskString() {
        var keyCombo: KeyCombo?
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⇧")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌘")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift, .control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⇧")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift, .control, .option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⌥⇧")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥⌘")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .shift, .option, .control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⌥⇧⌘")
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .option, .function, .capsLock, .numericPad, .help])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥⌘")
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "")
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌘")
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⇧")
    }

}
