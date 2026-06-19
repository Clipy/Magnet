//
//  HotKey.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Carbon

open class HotKey: NSObject {
    // MARK: - Properties
    public let identifier: String
    public let keyCombo: KeyCombo
    public let callback: ((HotKey) -> Void)?
    public let target: AnyObject?
    public let action: Selector?
    public let actionQueue: ActionQueue
    /// When enabled, Magnet auto re-registers this hot key after keyboard key code
    /// changes if the KeyCode that was registered no longer matches the KeyCode for
    /// the current input source.
    ///
    /// This is useful because macOS registers the layout-specific KeyCode that is
    /// current at registration time.
    /// For example, registering `v` uses KeyCode `9` on a QWERTY layout,
    /// but KeyCode `47` on a Dvorak layout. If the selected keyboard key codes
    /// change later, the registered hot key may no longer point to the intended
    /// physical key unless it is registered again.
    public let autoReRegisterOnKeyboardKeyCodesChange: Bool

    var hotKeyId: UInt32?
    var hotKeyRef: EventHotKeyRef?
    var registeredKeyCode: CGKeyCode?

    // MARK: - Enum Value
    public enum ActionQueue {
        case main
        case session

        public func execute(closure: @escaping () -> Void) {
            switch self {
            case .main:
                DispatchQueue.main.async {
                    closure()
                }
            case .session:
                closure()
            }
        }
    }

    // MARK: - Initialize
    public init(
        identifier: String,
        keyCombo: KeyCombo,
        target: AnyObject,
        action: Selector,
        actionQueue: ActionQueue = .main,
        autoReRegisterOnKeyboardKeyCodesChange: Bool = false
    ) {
        self.identifier = identifier
        self.keyCombo = keyCombo
        self.callback = nil
        self.target = target
        self.action = action
        self.actionQueue = actionQueue
        self.autoReRegisterOnKeyboardKeyCodesChange = autoReRegisterOnKeyboardKeyCodesChange
        super.init()
    }

    public init(
        identifier: String,
        keyCombo: KeyCombo,
        actionQueue: ActionQueue = .main,
        autoReRegisterOnKeyboardKeyCodesChange: Bool = false,
        handler: @escaping ((HotKey) -> Void)
    ) {
        self.identifier = identifier
        self.keyCombo = keyCombo
        self.callback = handler
        self.target = nil
        self.action = nil
        self.actionQueue = actionQueue
        self.autoReRegisterOnKeyboardKeyCodesChange = autoReRegisterOnKeyboardKeyCodesChange
        super.init()
    }
}

// MARK: - Invoke
extension HotKey {
    public func invoke() {
        guard let callback = self.callback else {
            guard let target = self.target as? NSObject, let selector = self.action else { return }
            guard target.responds(to: selector) else { return }
            actionQueue.execute { [weak self] in
                guard let wSelf = self else { return }
                target.perform(selector, with: wSelf)
            }
            return
        }
        actionQueue.execute { [weak self] in
            guard let wSelf = self else { return }
            callback(wSelf)
        }
    }
}

// MARK: - Register & UnRegister
extension HotKey {
    @discardableResult
    public func register() -> Bool {
        return HotKeyCenter.shared.register(with: self)
    }

    public func unregister() {
        return HotKeyCenter.shared.unregister(with: self)
    }
}

// MARK: - override isEqual
extension HotKey {
    override public func isEqual(_ object: Any?) -> Bool {
        guard let hotKey = object as? HotKey else { return false }

        return self.identifier == hotKey.identifier &&
               self.keyCombo == hotKey.keyCombo &&
               self.autoReRegisterOnKeyboardKeyCodesChange == hotKey.autoReRegisterOnKeyboardKeyCodesChange &&
               self.hotKeyId == hotKey.hotKeyId &&
               self.hotKeyRef == hotKey.hotKeyRef
    }
}
