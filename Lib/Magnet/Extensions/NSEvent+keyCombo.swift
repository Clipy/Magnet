//
//  NSEvent+keyCombo.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Sauce

extension NSEvent.EventType {
    fileprivate var isKeyboardEvent: Bool {
        return [.keyUp, .keyDown].contains(self)
    }
}

extension NSEvent {
    /// Returns a matching `KeyCombo` for the event, if the event is a keyboard event and the key is recognized.
    public var keyCombo: KeyCombo? {
        guard self.type.isKeyboardEvent else { return nil }
        guard let key = Sauce.shared.key(by: Int(self.keyCode)) else { return nil }
        return KeyCombo(key: key, cocoaModifiers: self.modifierFlags)
    }
}
