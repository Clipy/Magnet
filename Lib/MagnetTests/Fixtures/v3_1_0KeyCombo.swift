// 
//  v3_1_0KeyCombo.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import Foundation
import Sauce

// swiftlint:disable type_name
// ref: https://github.com/Clipy/Magnet/blob/v3.1.0/Lib/Magnet/KeyCombo.swift
final class v3_1_0KeyCombo: NSObject, NSCoding, Codable {

    // MARK: - Properties
    public let key: Key
    public let modifiers: Int
    public let doubledModifiers: Bool
    public var QWERTYKeyCode: Int {
        guard !doubledModifiers else { return 0 }
        return Int(key.QWERTYKeyCode)
    }

    // MARK: - Initialize
    init(key: Key, modifiers: Int, doubledModifiers: Bool) {
        self.key = key
        self.modifiers = modifiers
        self.doubledModifiers = doubledModifiers
    }

    public init?(coder aDecoder: NSCoder) {
        self.doubledModifiers = aDecoder.decodeBool(forKey: CodingKeys.doubledModifiers.rawValue)
        if doubledModifiers {
            self.key = .a
        } else {
            let QWERTYKeyCode = aDecoder.decodeInteger(forKey: CodingKeys.QWERTYKeyCode.rawValue)
            guard let key = Key(QWERTYKeyCode: QWERTYKeyCode) else { return nil }
            self.key = key
        }
        self.modifiers = aDecoder.decodeInteger(forKey: CodingKeys.modifiers.rawValue)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(QWERTYKeyCode, forKey: CodingKeys.QWERTYKeyCode.rawValue)
        aCoder.encode(modifiers, forKey: CodingKeys.modifiers.rawValue)
        aCoder.encode(doubledModifiers, forKey: CodingKeys.doubledModifiers.rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.doubledModifiers = try container.decode(Bool.self, forKey: .doubledModifiers)
        if doubledModifiers {
            self.key = .a
        } else {
            let QWERTYKeyCode = try container.decode(Int.self, forKey: .QWERTYKeyCode)
            guard let key = Key(QWERTYKeyCode: QWERTYKeyCode) else { throw NSError() }
            self.key = key
        }
        self.modifiers = try container.decode(Int.self, forKey: .modifiers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(QWERTYKeyCode, forKey: .QWERTYKeyCode)
        try container.encode(modifiers, forKey: .modifiers)
        try container.encode(doubledModifiers, forKey: .doubledModifiers)
    }

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case QWERTYKeyCode
        case modifiers
        case doubledModifiers
    }

}
