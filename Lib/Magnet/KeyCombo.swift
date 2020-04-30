//
//  KeyCombo.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Carbon
import Sauce

public final class KeyCombo: NSObject, NSCopying, NSCoding, Codable {

    // MARK: - Properties
    public let QWERTYKeyCode: Int
    public let modifiers: Int
    public let doubledModifiers: Bool
    public var characters: String {
        guard !doubledModifiers else { return "" }
        guard let key = Key(QWERTYKeyCode: QWERTYKeyCode) else { return "" }
        return Sauce.shared.character(by: Int(Sauce.shared.keyCode(by: key)), carbonModifiers: modifiers) ?? ""
    }

    // MARK: - Initialize
    public convenience init?(QWERTYKeyCode: Int, carbonModifiers: Int) {
        self.init(QWERTYKeyCode: QWERTYKeyCode, cocoaModifiers: carbonModifiers.convertSupportCococaModifiers())
    }

    public convenience init?(QWERTYKeyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) {
        guard let key = Key(QWERTYKeyCode: QWERTYKeyCode) else { return nil }
        self.init(key: key, cocoaModifiers: cocoaModifiers)
    }

    public convenience init?(key: Key, carbonModifiers: Int) {
        self.init(key: key, cocoaModifiers: carbonModifiers.convertSupportCococaModifiers())
    }

    public init?(key: Key, cocoaModifiers: NSEvent.ModifierFlags) {
        var filterdCocoaModifiers = cocoaModifiers.filterUnsupportModifiers()
        guard filterdCocoaModifiers.containsSupportModifiers else { return nil }
        // In the case of the function key, will need to add the modifier manually
        if key.isFunctionKey {
            filterdCocoaModifiers.insert(.function)
        }
        self.modifiers = filterdCocoaModifiers.carbonModifiers()
        self.QWERTYKeyCode = Int(key.QWERTYKeyCode)
        self.doubledModifiers = false
    }

    public convenience init?(doubledCarbonModifiers modifiers: Int) {
        self.init(doubledCocoaModifiers: modifiers.convertSupportCococaModifiers())
    }

    public init?(doubledCocoaModifiers modifiers: NSEvent.ModifierFlags) {
        guard modifiers.isSingleFlags else { return nil }
        self.modifiers = modifiers.carbonModifiers()
        self.QWERTYKeyCode = 0
        self.doubledModifiers = true
    }

    public func copy(with zone: NSZone?) -> Any {
        if doubledModifiers {
            return KeyCombo(doubledCarbonModifiers: modifiers) as Any
        } else {
            return KeyCombo(QWERTYKeyCode: QWERTYKeyCode, carbonModifiers: modifiers) as Any
        }
    }

    public init?(coder aDecoder: NSCoder) {
        // Changed KeyCode to QWERTYKeyCode from v3.0.0
        let containsKeyCode = aDecoder.containsValue(forKey: "keyCode")
        if containsKeyCode {
            self.QWERTYKeyCode = aDecoder.decodeInteger(forKey: "keyCode")
        } else {
            self.QWERTYKeyCode = aDecoder.decodeInteger(forKey: "QWERTYKeyCode")
        }
        self.modifiers = aDecoder.decodeInteger(forKey: "modifiers")
        self.doubledModifiers = aDecoder.decodeBool(forKey: "doubledModifiers")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(QWERTYKeyCode, forKey: "QWERTYKeyCode")
        aCoder.encode(modifiers, forKey: "modifiers")
        aCoder.encode(doubledModifiers, forKey: "doubledModifiers")
    }

    // MARK: - Equatable
    public override func isEqual(_ object: Any?) -> Bool {
        guard let keyCombo = object as? KeyCombo else { return false }
        return QWERTYKeyCode == keyCombo.QWERTYKeyCode &&
                modifiers == keyCombo.modifiers &&
                doubledModifiers == keyCombo.doubledModifiers
    }

}
