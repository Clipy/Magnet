//
//  KeyComboTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015 Clipy Project.
//

import Carbon
import Cocoa
import Sauce
import Testing
@testable import Magnet

// swiftlint:disable identifier_name
// swiftlint:disable:next type_body_length
struct KeyComboTests {
    private let functionModifierRawValue = Int(NSEvent.ModifierFlags.function.rawValue)

    private func unarchiveKeyCombo(from data: Data) throws -> KeyCombo {
        let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let object = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? KeyCombo
        unarchiver.finishDecoding()
        return try #require(object)
    }

    // MARK: - Tests
    @Test
    func functionInitializer() {
        // F1
        #expect(KeyCombo(key: .f1, cocoaModifiers: []) != nil)
        // Shift + Control + Comman + Option + F1
        #expect(KeyCombo(key: .f1, cocoaModifiers: [.shift, .control, .command, .option]) != nil)
    }

    @Test
    func doubledTapKeyComboInitializer() {
        // Shift double tap
        #expect(KeyCombo(doubledCocoaModifiers: .shift) != nil)
        // Empty double tap
        #expect(KeyCombo(doubledCocoaModifiers: []) == nil)
        // Shift + Control double tap
        #expect(KeyCombo(doubledCocoaModifiers: [.shift, .command]) == nil)
        // Function double tap
        #expect(KeyCombo(doubledCocoaModifiers: [.function]) == nil)
    }

    @Test
    func doubledTapKeyComboCharacter() throws {
        // Shift double tap
        let shiftDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .shift))
        #expect(shiftDoubleTap.characters == "")

        // Control double tap
        let controlDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .control))
        #expect(controlDoubleTap.characters == "")

        // Command double tap
        let commandDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .command))
        #expect(commandDoubleTap.characters == "")

        // Option double tap
        let optionDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .option))
        #expect(optionDoubleTap.characters == "")
    }

    @Test
    func character() throws {
        // Command + a
        let commandA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command]))
        #expect(commandA.characters == "a")

        // Shift + a
        let shiftA = try #require(KeyCombo(key: .a, cocoaModifiers: [.shift]))
        #expect(shiftA.characters == "A")

        // Option + a
        let optionA = try #require(KeyCombo(key: .a, cocoaModifiers: [.option]))
        #expect(optionA.characters == "å")

        // Option + Shift + a
        let optionShiftA = try #require(KeyCombo(key: .a, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftA.characters == "Å")

        // Option + Shift + 1
        let optionShiftOne = try #require(KeyCombo(key: .one, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftOne.characters == "⁄")

        // Option + Shift + KeyPad 1
        let optionShiftKeypadOne = try #require(KeyCombo(key: .keypadOne, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftKeypadOne.characters == "1")

        // Option + ;
        let optionSemicolon = try #require(KeyCombo(key: .semicolon, cocoaModifiers: [.option]))
        #expect(optionSemicolon.characters == "…")

        // Shift + F1
        let shiftF1 = try #require(KeyCombo(key: .f1, cocoaModifiers: [.shift]))
        #expect(shiftF1.characters == "F1")
    }

    @Test
    func keyEquivalent() throws {
        // Command + a
        let commandA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command]))
        #expect(commandA.keyEquivalent == "a")

        // Shift + a
        let shiftA = try #require(KeyCombo(key: .a, cocoaModifiers: [.shift]))
        #expect(shiftA.keyEquivalent == "A")

        // Option + a
        let optionA = try #require(KeyCombo(key: .a, cocoaModifiers: [.option]))
        #expect(optionA.keyEquivalent == "a")

        // Option + Shift + a
        let optionShiftA = try #require(KeyCombo(key: .a, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftA.keyEquivalent == "A")

        // Option + Shift + 1
        let optionShiftOne = try #require(KeyCombo(key: .one, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftOne.keyEquivalent == "1")

        // Option + Shift + Keypad 1
        let optionShiftKeypadOne = try #require(KeyCombo(key: .keypadOne, cocoaModifiers: [.option, .shift]))
        #expect(optionShiftKeypadOne.keyEquivalent == "1")

        // Option + ;
        let optionSemicolon = try #require(KeyCombo(key: .semicolon, cocoaModifiers: [.option]))
        #expect(optionSemicolon.keyEquivalent == ";")

        // Shift + F1
        let shiftF1 = try #require(KeyCombo(key: .f1, cocoaModifiers: [.shift]))
        #expect(shiftF1.keyEquivalent == "F1")

        // Option double tap
        let optionDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .option))
        #expect(optionDoubleTap.keyEquivalent == "")
    }

    @Test
    func keyEquivalentModifierMaskString() throws {
        // Shift + a
        let shiftA = try #require(KeyCombo(key: .a, cocoaModifiers: [.shift]))
        #expect(shiftA.keyEquivalentModifierMaskString == "⇧")

        // Control + a
        let controlA = try #require(KeyCombo(key: .a, cocoaModifiers: [.control]))
        #expect(controlA.keyEquivalentModifierMaskString == "⌃")

        // Command + a
        let commandA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command]))
        #expect(commandA.keyEquivalentModifierMaskString == "⌘")

        // Option + a
        let optionA = try #require(KeyCombo(key: .a, cocoaModifiers: [.option]))
        #expect(optionA.keyEquivalentModifierMaskString == "⌥")

        // Shift + Control + a
        let shiftControlA = try #require(KeyCombo(key: .a, cocoaModifiers: [.shift, .control]))
        #expect(shiftControlA.keyEquivalentModifierMaskString == "⌃⇧")

        // Shift + Control + Option + a
        let shiftControlOptionA = try #require(KeyCombo(key: .a, cocoaModifiers: [.shift, .control, .option]))
        #expect(shiftControlOptionA.keyEquivalentModifierMaskString == "⌃⌥⇧")

        // Command + Option + a
        let commandOptionA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command, .option]))
        #expect(commandOptionA.keyEquivalentModifierMaskString == "⌥⌘")

        // Command + Shift + Option + Control + a
        let commandShiftOptionControlA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command, .shift, .option, .control]))
        #expect(commandShiftOptionControlA.keyEquivalentModifierMaskString == "⌃⌥⇧⌘")

        // Command + Option + Function + CapsLock + NumericPad + Help + a
        let commandOptionExtendedA = try #require(KeyCombo(key: .a, cocoaModifiers: [.command, .option, .function, .capsLock, .numericPad, .help]))
        #expect(commandOptionExtendedA.keyEquivalentModifierMaskString == "⌥⌘")

        // F1
        let f1 = try #require(KeyCombo(key: .f1, cocoaModifiers: []))
        #expect(f1.keyEquivalentModifierMaskString == "")

        // Command + F1
        let commandF1 = try #require(KeyCombo(key: .f1, cocoaModifiers: [.command]))
        #expect(commandF1.keyEquivalentModifierMaskString == "⌘")

        // Shift Double tap
        let shiftDoubleTap = try #require(KeyCombo(doubledCocoaModifiers: .shift))
        #expect(shiftDoubleTap.keyEquivalentModifierMaskString == "⇧")
    }

    @Test
    func nsCodingMigrationV3_0() throws {
        var oldKeyCombo: v2_0_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        NSKeyedUnarchiver.setClass(KeyCombo.self, forClassName: "MagnetTests.v2_0_0KeyCombo")

        // Shift + v
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_ANSI_V, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedShiftV = try #require(unarchivedKeyCombo)
        #expect(migratedShiftV.key == .v)
        #expect(migratedShiftV.modifiers == shiftKey)
        #expect(migratedShiftV.doubledModifiers == false)

        // F3
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_F3, modifiers: functionModifierRawValue, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedF3 = try #require(unarchivedKeyCombo)
        #expect(migratedF3.key == .f3)
        #expect(migratedF3.modifiers == functionModifierRawValue)
        #expect(migratedF3.doubledModifiers == false)

        // Control double tap
        oldKeyCombo = v2_0_0KeyCombo(keyCode: 0, modifiers: controlKey, doubledModifiers: true)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedControlDoubleTap = try #require(unarchivedKeyCombo)
        #expect(migratedControlDoubleTap.key == .a)
        #expect(migratedControlDoubleTap.modifiers == controlKey)
        #expect(migratedControlDoubleTap.doubledModifiers == true)

        // Shift + @
        oldKeyCombo = v2_0_0KeyCombo(keyCode: Int(Key.atSign.QWERTYKeyCode), modifiers: shiftKey, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedShiftAtSign = try #require(unarchivedKeyCombo)
        #expect(migratedShiftAtSign.key == .leftBracket)
        #expect(migratedShiftAtSign.modifiers == shiftKey)
        #expect(migratedShiftAtSign.doubledModifiers == false)
    }

    @Test
    func nsCodingMigrationV3_1() throws {
        var oldKeyCombo: v3_1_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?
        NSKeyedUnarchiver.setClass(KeyCombo.self, forClassName: "MagnetTests.v3_1_0KeyCombo")

        // Shift + v
        oldKeyCombo = v3_1_0KeyCombo(key: .v, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedShiftV = try #require(unarchivedKeyCombo)
        #expect(migratedShiftV.key == .v)
        #expect(migratedShiftV.modifiers == shiftKey)
        #expect(migratedShiftV.doubledModifiers == false)

        // F3
        oldKeyCombo = v3_1_0KeyCombo(key: .f3, modifiers: functionModifierRawValue, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedF3 = try #require(unarchivedKeyCombo)
        #expect(migratedF3.key == .f3)
        #expect(migratedF3.modifiers == functionModifierRawValue)
        #expect(migratedF3.doubledModifiers == false)

        // Control double tap
        oldKeyCombo = v3_1_0KeyCombo(key: .a, modifiers: controlKey, doubledModifiers: true)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedControlDoubleTap = try #require(unarchivedKeyCombo)
        #expect(migratedControlDoubleTap.key == .a)
        #expect(migratedControlDoubleTap.modifiers == controlKey)
        #expect(migratedControlDoubleTap.doubledModifiers == true)

        // Shift + @
        oldKeyCombo = v3_1_0KeyCombo(key: .atSign, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(oldKeyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let migratedShiftAtSign = try #require(unarchivedKeyCombo)
        #expect(migratedShiftAtSign.key == .leftBracket)
        #expect(migratedShiftAtSign.modifiers == shiftKey)
        #expect(migratedShiftAtSign.doubledModifiers == false)
    }

    @Test
    func nsCoding() throws {
        var keyCombo: KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?

        // Shift + Control + c
        keyCombo = KeyCombo(key: .c, cocoaModifiers: [.shift, .control])
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(keyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let originalShiftControlC = try #require(keyCombo)
        let unarchivedShiftControlC = try #require(unarchivedKeyCombo)
        #expect(unarchivedShiftControlC == originalShiftControlC)

        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(keyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let originalF1 = try #require(keyCombo)
        let unarchivedF1 = try #require(unarchivedKeyCombo)
        #expect(unarchivedF1 == originalF1)

        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.option])
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(keyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let originalOptionDoubleTap = try #require(keyCombo)
        let unarchivedOptionDoubleTap = try #require(unarchivedKeyCombo)
        #expect(unarchivedOptionDoubleTap == originalOptionDoubleTap)

        // Shift + @
        keyCombo = KeyCombo(key: .atSign, cocoaModifiers: [.shift])
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(keyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let originalShiftAtSign = try #require(keyCombo)
        let unarchivedShiftAtSign = try #require(unarchivedKeyCombo)
        #expect(unarchivedShiftAtSign == originalShiftAtSign)

        // Control + [
        keyCombo = KeyCombo(key: .leftBracket, cocoaModifiers: [.control])
        archivedData = try NSKeyedArchiver.archivedData(withRootObject: try #require(keyCombo), requiringSecureCoding: false)
        unarchivedKeyCombo = try unarchiveKeyCombo(from: try #require(archivedData))
        let originalControlLeftBracket = try #require(keyCombo)
        let unarchivedControlLeftBracket = try #require(unarchivedKeyCombo)
        #expect(unarchivedControlLeftBracket == originalControlLeftBracket)
    }

    @Test
    func codableMigrationV3_0() throws {
        var oldKeyCombo: v2_0_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?

        // Shift + v
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_ANSI_V, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedShiftV = try #require(unarchivedKeyCombo)
        #expect(migratedShiftV.key == .v)
        #expect(migratedShiftV.modifiers == shiftKey)
        #expect(migratedShiftV.doubledModifiers == false)

        // F3
        oldKeyCombo = v2_0_0KeyCombo(keyCode: kVK_F3, modifiers: functionModifierRawValue, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedF3 = try #require(unarchivedKeyCombo)
        #expect(migratedF3.key == .f3)
        #expect(migratedF3.modifiers == functionModifierRawValue)
        #expect(migratedF3.doubledModifiers == false)

        // Control double tap
        oldKeyCombo = v2_0_0KeyCombo(keyCode: 0, modifiers: controlKey, doubledModifiers: true)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedControlDoubleTap = try #require(unarchivedKeyCombo)
        #expect(migratedControlDoubleTap.key == .a)
        #expect(migratedControlDoubleTap.modifiers == controlKey)
        #expect(migratedControlDoubleTap.doubledModifiers == true)

        // Shift + @
        oldKeyCombo = v2_0_0KeyCombo(keyCode: Int(Key.atSign.QWERTYKeyCode), modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedShiftAtSign = try #require(unarchivedKeyCombo)
        #expect(migratedShiftAtSign.key == .leftBracket)
        #expect(migratedShiftAtSign.modifiers == shiftKey)
        #expect(migratedShiftAtSign.doubledModifiers == false)
    }

    @Test
    func codableMigrationV3_1() throws {
        var oldKeyCombo: v3_1_0KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?

        // Shift + v
        oldKeyCombo = v3_1_0KeyCombo(key: .v, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedShiftV = try #require(unarchivedKeyCombo)
        #expect(migratedShiftV.key == .v)
        #expect(migratedShiftV.modifiers == shiftKey)
        #expect(migratedShiftV.doubledModifiers == false)

        // F3
        oldKeyCombo = v3_1_0KeyCombo(key: .f3, modifiers: functionModifierRawValue, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedF3 = try #require(unarchivedKeyCombo)
        #expect(migratedF3.key == .f3)
        #expect(migratedF3.modifiers == functionModifierRawValue)
        #expect(migratedF3.doubledModifiers == false)

        // Control double tap
        oldKeyCombo = v3_1_0KeyCombo(key: .a, modifiers: controlKey, doubledModifiers: true)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedControlDoubleTap = try #require(unarchivedKeyCombo)
        #expect(migratedControlDoubleTap.key == .a)
        #expect(migratedControlDoubleTap.modifiers == controlKey)
        #expect(migratedControlDoubleTap.doubledModifiers == true)

        // Shift + @
        oldKeyCombo = v3_1_0KeyCombo(key: .atSign, modifiers: shiftKey, doubledModifiers: false)
        archivedData = try JSONEncoder().encode(try #require(oldKeyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let migratedShiftAtSign = try #require(unarchivedKeyCombo)
        #expect(migratedShiftAtSign.key == .leftBracket)
        #expect(migratedShiftAtSign.modifiers == shiftKey)
        #expect(migratedShiftAtSign.doubledModifiers == false)
    }

    @Test
    func codable() throws {
        var keyCombo: KeyCombo?
        var archivedData: Data?
        var unarchivedKeyCombo: KeyCombo?

        // Shift + Control + c
        keyCombo = KeyCombo(key: .c, cocoaModifiers: [.shift, .control])
        archivedData = try JSONEncoder().encode(try #require(keyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let decodedShiftControlC = try #require(unarchivedKeyCombo)
        let encodedShiftControlC = try #require(keyCombo)
        #expect(decodedShiftControlC == encodedShiftControlC)

        // F1
        keyCombo = KeyCombo(key: .f1, cocoaModifiers: [])
        archivedData = try JSONEncoder().encode(try #require(keyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let decodedF1 = try #require(unarchivedKeyCombo)
        let encodedF1 = try #require(keyCombo)
        #expect(decodedF1 == encodedF1)

        // Option double tap
        keyCombo = KeyCombo(doubledCocoaModifiers: [.option])
        archivedData = try JSONEncoder().encode(try #require(keyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let decodedOptionDoubleTap = try #require(unarchivedKeyCombo)
        let encodedOptionDoubleTap = try #require(keyCombo)
        #expect(decodedOptionDoubleTap == encodedOptionDoubleTap)

        // Shift + @
        keyCombo = KeyCombo(key: .atSign, cocoaModifiers: [.shift])
        archivedData = try JSONEncoder().encode(try #require(keyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let decodedShiftAtSign = try #require(unarchivedKeyCombo)
        let encodedShiftAtSign = try #require(keyCombo)
        #expect(decodedShiftAtSign == encodedShiftAtSign)

        // Control + [
        keyCombo = KeyCombo(key: .leftBracket, cocoaModifiers: [.control])
        archivedData = try JSONEncoder().encode(try #require(keyCombo))
        unarchivedKeyCombo = try JSONDecoder().decode(KeyCombo.self, from: try #require(archivedData))
        let decodedControlLeftBracket = try #require(unarchivedKeyCombo)
        let encodedControlLeftBracket = try #require(keyCombo)
        #expect(decodedControlLeftBracket == encodedControlLeftBracket)
    }
}

// swiftlint:enable identifier_name
