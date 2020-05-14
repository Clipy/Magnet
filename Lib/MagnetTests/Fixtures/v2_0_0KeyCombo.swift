// 
//  v2_0_0KeyCombo.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa

// swiftlint:disable type_name
// ref: https://github.com/Clipy/Magnet/blob/v2.3.1/Lib/Magnet/KeyCombo.swift
final class v2_0_0KeyCombo: NSObject, NSCoding, Codable {

    // MARK: - Properties
    public let keyCode: Int
    public let modifiers: Int
    public let doubledModifiers: Bool

    // MARK: - Initialize
    init(keyCode: Int, modifiers: Int, doubledModifiers: Bool) {
        self.keyCode = keyCode
        self.modifiers = modifiers
        self.doubledModifiers = doubledModifiers
    }

    public init?(coder aDecoder: NSCoder) {
        self.keyCode = aDecoder.decodeInteger(forKey: "keyCode")
        self.modifiers = aDecoder.decodeInteger(forKey: "modifiers")
        self.doubledModifiers = aDecoder.decodeBool(forKey: "doubledModifiers")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(keyCode, forKey: "keyCode")
        aCoder.encode(modifiers, forKey: "modifiers")
        aCoder.encode(doubledModifiers, forKey: "doubledModifiers")
    }

}
