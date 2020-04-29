//
//  KeyTransformer.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Carbon

public final class KeyTransformer {}

// MARK: - Cocoa & Carbon
public extension KeyTransformer {
    static func cocoaFlags(from carbonFlags: Int) -> NSEvent.ModifierFlags {
        var cocoaFlags: NSEvent.ModifierFlags = NSEvent.ModifierFlags(rawValue: 0)

        if (carbonFlags & cmdKey) != 0 {
            cocoaFlags.insert(.command)
        }
        if (carbonFlags & optionKey) != 0 {
            cocoaFlags.insert(.option)
        }
        if (carbonFlags & controlKey) != 0 {
            cocoaFlags.insert(.control)
        }
        if (carbonFlags & shiftKey) != 0 {
            cocoaFlags.insert(.shift)
        }

        return cocoaFlags
    }

    static func carbonFlags(from cocoaFlags: NSEvent.ModifierFlags) -> Int {
        var carbonFlags: Int = 0

        if cocoaFlags.contains(.command) {
            carbonFlags |= cmdKey
        }
        if cocoaFlags.contains(.option) {
            carbonFlags |= optionKey
        }
        if cocoaFlags.contains(.control) {
            carbonFlags |= controlKey
        }
        if cocoaFlags.contains(.shift) {
            carbonFlags |= shiftKey
        }

        return carbonFlags
    }

    static func supportedCarbonFlags(_ carbonFlags: Int) -> Bool {
        return cocoaFlags(from: carbonFlags).rawValue != 0
    }

    static func supportedCocoaFlags(_ cocoaFlogs: NSEvent.ModifierFlags) -> Bool {
        return carbonFlags(from: cocoaFlogs) != 0
    }

    static func singleCarbonFlags(_ carbonFlags: Int) -> Bool {
        let commandSelected = (carbonFlags & cmdKey) != 0
        let optionSelected = (carbonFlags & optionKey) != 0
        let controlSelected = (carbonFlags & controlKey) != 0
        let shiftSelected = (carbonFlags & shiftKey) != 0
        return [commandSelected, optionSelected, controlSelected, shiftSelected].trueCount == 1
    }

    static func singleCocoaFlags(_ cocoaFlags: NSEvent.ModifierFlags) -> Bool {
        let commandSelected = cocoaFlags.contains(.command)
        let optionSelected = cocoaFlags.contains(.option)
        let controlSelected = cocoaFlags.contains(.control)
        let shiftSelected = cocoaFlags.contains(.shift)
        return [commandSelected, optionSelected, controlSelected, shiftSelected].trueCount == 1
    }
}

// MARK: - Function
public extension KeyTransformer {
    static func containsFunctionKey(_ keyCode: Int) -> Bool {
        switch keyCode {
        case kVK_F1,
             kVK_F2,
             kVK_F3,
             kVK_F4,
             kVK_F5,
             kVK_F6,
             kVK_F7,
             kVK_F8,
             kVK_F9,
             kVK_F10,
             kVK_F11,
             kVK_F12,
             kVK_F13,
             kVK_F14,
             kVK_F15,
             kVK_F16,
             kVK_F17,
             kVK_F18,
             kVK_F19,
             kVK_F20:
            return true
        default:
            return false
        }
    }
}

// MARK: - Modifiers
public extension KeyTransformer {
    static func modifiersToString(_ carbonModifiers: Int) -> [String] {
        var strings = [String]()

        if (carbonModifiers & cmdKey) != 0 {
            strings.append("⌘")
        }
        if (carbonModifiers & optionKey) != 0 {
            strings.append("⌥")
        }
        if (carbonModifiers & controlKey) != 0 {
            strings.append("⌃")
        }
        if (carbonModifiers & shiftKey) != 0 {
            strings.append("⇧")
        }

        return strings
    }

    static func modifiersToString(_ cocoaModifiers: NSEvent.ModifierFlags) -> [String] {
        var strings = [String]()

        if cocoaModifiers.contains(.command) {
            strings.append("⌘")
        }
        if cocoaModifiers.contains(.option) {
            strings.append("⌥")
        }
        if cocoaModifiers.contains(.control) {
            strings.append("⌃")
        }
        if cocoaModifiers.contains(.shift) {
            strings.append("⇧")
        }

        return strings
    }
}
