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
import Sauce
import Carbon
@testable import Magnet

final class KeyComboTests: XCTestCase {

    // MARK: - Tests
    func testFunctionInitializer() {
        var keyCombo: KeyCombo?
        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        XCTAssertNotNil(keyCombo)
        // Shift + Control + Comman + Option + F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift, .control, .command, .option])
        XCTAssertNotNil(keyCombo)
    }

    func testDoubledTapKeyComboInitializer() {
        var keyCombo: KeyCombo?
        // Shift double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertNotNil(keyCombo)
        // Empty double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [])
        XCTAssertNil(keyCombo)
        // Shift + Control double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.shift, .command])
        XCTAssertNil(keyCombo)
        // Function double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.function])
        XCTAssertNil(keyCombo)
    }

    func testDoubledTapKeyComboCharacter() {
        var keyCombo: KeyCombo?
        // Shift double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertEqual(keyCombo?.characters, "")
        // Control double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .control)
        XCTAssertEqual(keyCombo?.characters, "")
        // Command double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .command)
        XCTAssertEqual(keyCombo?.characters, "")
        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.characters, "")
    }

    func testCharacter() {
        var keyCombo: KeyCombo?
        // Command + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.characters, "a")
        // Shift + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.characters, "A")
        // Option + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.characters, "å")
        // Option + Shift + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.characters, "Å")
        // Option + Shift + 1
        keyCombo = KeyCombo(key: .one, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.characters, "⁄")
        // Option + Shift + KeyPad 1
        keyCombo = KeyCombo(key: .keypadOne, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.characters, "1")
        // Option + ;
        keyCombo = KeyCombo(key: .semicolon, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.characters, "…")
        // Shift + F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.characters, "F1")
        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.characters, "")
    }

    func testKeyEquivalent() {
        var keyCombo: KeyCombo?
        // Command + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalent, "a")
        // Shift + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "A")
        // Option + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalent, "a")
        // Option + Shift + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "A")
        // Option + Shift + 1
        keyCombo = KeyCombo(key: .one, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "1")
        // Option + Shift + Keypad 1
        keyCombo = KeyCombo(key: .keypadOne, cocoaModifiers: [.option, .shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "1")
        // Option + ;
        keyCombo = KeyCombo(key: .semicolon, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalent, ";")
        // Shift + F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalent, "F1")
        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .option)
        XCTAssertEqual(keyCombo?.keyEquivalent, "")
    }

    func testKeyEquivalentModifierMaskString() {
        var keyCombo: KeyCombo?
        // Shift + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⇧")
        // Control + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃")
        // Command + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌘")
        // Option + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥")
        // Shift + Control + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift, .control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⇧")
        // Shift + Control + Option + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.shift, .control, .option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⌥⇧")
        // Command + Option + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .option])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥⌘")
        // Command + Shift + Option + Control + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .shift, .option, .control])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌃⌥⇧⌘")
        // Command + Option + Function + CapsLock + NumericPad + Help + a
        keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command, .option, .function, .capsLock, .numericPad, .help])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌥⌘")
        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "")
        // Command + F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [.command])
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⌘")
        // Shift Double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: .shift)
        XCTAssertEqual(keyCombo?.keyEquivalentModifierMaskString, "⇧")
    }

    func testNSCodingMigrationV3_0() {
        var oldKeyCombo: v2_0_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        NSKeyedUnarchiver.setClass(KeyCombo.self, forClassName: "MagnetTests.v2_0_0KeyCombo")
        // Shift + v
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_ANSI_V, modifiers: shiftKey, doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .v)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // F3
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_F3, modifiers: Int(NSEvent.ModifierFlags.function.rawValue), doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .f3)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, Int(NSEvent.ModifierFlags.function.rawValue))
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // Control double tap
        oldKeyCombo = v2_0_0KeyCombo(keyCode: 0, modifiers: controlKey, doubledModifiers: true)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .a)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, controlKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, true)
        // Shift + @
        oldKeyCombo = v2_0_0KeyCombo(keyCode: Int(Key.atSign.QWERTYKeyCode), modifiers: shiftKey, doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .leftBracket)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
    }

    func testNSCodingMigrationV3_1() {
        var oldKeyCombo: v3_1_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        NSKeyedUnarchiver.setClass(KeyCombo.self, forClassName: "MagnetTests.v3_1_0KeyCombo")
        // Shift + v
        oldKeyCombo = v3_1_0KeyCombo(key: .v, modifiers: shiftKey, doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .v)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // F3
        oldKeyCombo = v3_1_0KeyCombo(key: .f3, modifiers: Int(NSEvent.ModifierFlags.function.rawValue), doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .f3)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, Int(NSEvent.ModifierFlags.function.rawValue))
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // Control double tap
        oldKeyCombo = v3_1_0KeyCombo(key: .a, modifiers: controlKey, doubledModifiers: true)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .a)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, controlKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, true)
        // Shift + @
        oldKeyCombo = v3_1_0KeyCombo(key: .atSign, modifiers: shiftKey, doubledModifiers: false)
        archivedData = NSKeyedArchiver.archivedData(withRootObject: oldKeyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .leftBracket)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
    }

    func testNSCoding() {
        var keyCombo: KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        // Shift + Control + c
        keyCombo = KeyCombo(key: .c, cocoaModifiers: [.shift, .control])
        archivedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        archivedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.option])
        archivedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Shift + @
        keyCombo = KeyCombo(key: .atSign, cocoaModifiers: [.shift])
        archivedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Control + [
        keyCombo = KeyCombo(key: .leftBracket, cocoaModifiers: [.control])
        archivedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo!)
        unarchivedKeyCombo = NSKeyedUnarchiver.unarchiveObject(with: archivedData!) as? KeyCombo
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
    }

    func testCodableMigrationV3_0() throws {
        var oldKeyCombo: v2_0_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        // Shift + v
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_ANSI_V, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .v)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // F3
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_F3, modifiers: Int(NSEvent.ModifierFlags.function.rawValue), doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .f3)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, Int(NSEvent.ModifierFlags.function.rawValue))
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // Control double tap
        oldKeyCombo = v2_0_0KeyCombo(keyCode: 0, modifiers: controlKey, doubledModifiers: true)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .a)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, controlKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, true)
        // Shift + @
        oldKeyCombo = v2_0_0KeyCombo(keyCode: Int(Key.atSign.QWERTYKeyCode), modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .leftBracket)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
    }

    func testCodableMigrationV3_1() throws {
        var oldKeyCombo: v3_1_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        // Shift + v
        oldKeyCombo = v3_1_0KeyCombo(key: .v, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .v)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // F3
        oldKeyCombo = v3_1_0KeyCombo(key: .f3, modifiers: Int(NSEvent.ModifierFlags.function.rawValue), doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .f3)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, Int(NSEvent.ModifierFlags.function.rawValue))
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
        // Control double tap
        oldKeyCombo = v3_1_0KeyCombo(key: .a, modifiers: controlKey, doubledModifiers: true)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .a)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, controlKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, true)
        // Shift + @
        oldKeyCombo = v3_1_0KeyCombo(key: .atSign, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(oldKeyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(unarchivedKeyCombo?.key, .leftBracket)
        XCTAssertEqual(unarchivedKeyCombo?.modifiers, shiftKey)
        XCTAssertEqual(unarchivedKeyCombo?.doubledModifiers, false)
    }

    func testCodable() throws {
        var keyCombo: KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        // Shift + Control + c
        keyCombo = KeyCombo(key: .c, cocoaModifiers: [.shift, .control])
        archivedData = try JSONEncoder().encode(keyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        archivedData = try JSONEncoder().encode(keyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.option])
        archivedData = try JSONEncoder().encode(keyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Shift + @
        keyCombo = KeyCombo(key: .atSign, cocoaModifiers: [.shift])
        archivedData = try JSONEncoder().encode(keyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
        // Control + [
        keyCombo = KeyCombo(key: .leftBracket, cocoaModifiers: [.control])
        archivedData = try JSONEncoder().encode(keyCombo!)
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: archivedData!)
        XCTAssertNotNil(unarchivedKeyCombo)
        XCTAssertEqual(keyCombo, unarchivedKeyCombo)
    }

}
