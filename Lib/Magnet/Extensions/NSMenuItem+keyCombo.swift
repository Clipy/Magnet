//
//  NSMenuItem+keyCombo.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Sauce

extension NSMenuItem {
    /// The `KeyCombo` corresponsing to the receiver's shortcut.
    ///
    /// Prefers user-customized shortcuts (via "System Preferences" > "Keyboard") over the app's defaults.
    public var keyCombo: KeyCombo? {
        guard let key = self.key else { return nil }
        return KeyCombo(key: key, cocoaModifiers: self.keyEquivalentModifierMask)
    }
}
