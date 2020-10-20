// 
//  IntExtension.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Carbon

public extension Int {
    @available(*, deprecated, renamed: "NSEvent.ModifierFlags.init(carbonModifiers:)")
    func convertSupportCococaModifiers() -> NSEvent.ModifierFlags {
        return convertSupportCocoaModifiers()
    }

    @available(*, deprecated, renamed: "NSEvent.ModifierFlags.init(carbonModifiers:)")
    func convertSupportCocoaModifiers() -> NSEvent.ModifierFlags {
        return NSEvent.ModifierFlags(carbonModifiers: self)
    }
}
