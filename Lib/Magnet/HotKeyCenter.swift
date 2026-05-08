//
//  HotKeyCenter.swift
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

open class HotKeyCenter {
    // MARK: - Properties
    public static let shared = HotKeyCenter()

    private var hotKeys = [String: HotKey]()
    private var hotKeyCount: UInt32 = 0
    private let modifierEventHandler: ModifierEventHandler
    private let notificationCenter: NotificationCenter

    // MARK: - Initialize
    init(modifierEventHandler: ModifierEventHandler = .init(), notificationCenter: NotificationCenter = .default) {
        self.modifierEventHandler = modifierEventHandler
        self.notificationCenter = notificationCenter
        installHotKeyPressedEventHandler()
        installModifiersChangedEventHandlerIfNeeded()
        observeKeyboardLayoutChanges()
        observeApplicationTerminate()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}

// MARK: - Register
extension HotKeyCenter {
    @discardableResult
    public func register(with hotKey: HotKey) -> Bool {
        guard !hotKeys.keys.contains(hotKey.identifier) else { return false }
        guard !hotKeys.values.contains(hotKey) else { return false }

        hotKeys[hotKey.identifier] = hotKey
        guard !hotKey.keyCombo.doubledModifiers else { return true }
        guard registerEvent(with: hotKey) else {
            unregister(with: hotKey)
            return false
        }

        return true
    }

    @discardableResult
    private func registerEvent(with hotKey: HotKey) -> Bool {
        let hotKeyId = EventHotKeyID(signature: UTGetOSTypeFromString("Magnet" as CFString), id: hotKeyCount)
        var carbonHotKey: EventHotKeyRef?
        let currentKeyCode = hotKey.keyCombo.currentKeyCode
        let error = RegisterEventHotKey(UInt32(currentKeyCode),
                                        UInt32(hotKey.keyCombo.modifiers),
                                        hotKeyId,
                                        GetEventDispatcherTarget(),
                                        0,
                                        &carbonHotKey)
        guard error == noErr else { return false }
        hotKey.hotKeyId = hotKeyId.id
        hotKey.hotKeyRef = carbonHotKey
        hotKey.registeredKeyCode = currentKeyCode
        hotKeyCount += 1

        return true
    }
}

// MARK: - Unregister
extension HotKeyCenter {
    public func unregister(with hotKey: HotKey) {
        unregisterEvent(with: hotKey)
        hotKeys.removeValue(forKey: hotKey.identifier)
    }

    @discardableResult
    public func unregisterHotKey(with identifier: String) -> Bool {
        guard let hotKey = hotKeys[identifier] else { return false }
        unregister(with: hotKey)
        return true
    }

    public func unregisterAll() {
        hotKeys.forEach { unregister(with: $1) }
    }

    private func unregisterEvent(with hotKey: HotKey) {
        if let carbonHotKey = hotKey.hotKeyRef {
            UnregisterEventHotKey(carbonHotKey)
        }
        hotKey.hotKeyId = nil
        hotKey.hotKeyRef = nil
        hotKey.registeredKeyCode = nil
    }
}

// MARK: - Notifications
extension HotKeyCenter {
    private func observeApplicationTerminate() {
        notificationCenter.addObserver(self,
                                       selector: #selector(HotKeyCenter.applicationWillTerminate),
                                       name: NSApplication.willTerminateNotification,
                                       object: nil)
    }

    private func observeKeyboardLayoutChanges() {
        notificationCenter.addObserver(self,
                                       selector: #selector(HotKeyCenter.selectedKeyboardKeyCodesChanged),
                                       name: .SauceSelectedKeyboardKeyCodesChanged,
                                       object: nil)
    }

    @objc func applicationWillTerminate() {
        unregisterAll()
    }

    @objc func selectedKeyboardKeyCodesChanged() {
        hotKeys.values
            .filter { $0.autoReRegisterOnKeyboardLayoutChange }
            .filter { !$0.keyCombo.doubledModifiers }
            .forEach { hotKey in
                let currentKeyCode = hotKey.keyCombo.currentKeyCode
                guard hotKey.registeredKeyCode != currentKeyCode else { return }
                unregisterEvent(with: hotKey)
                registerEvent(with: hotKey)
            }
    }
}

// MARK: - HotKey Events
extension HotKeyCenter {
    public func installHotKeyPressedEventHandler() {
        var pressedEventType = EventTypeSpec()
        pressedEventType.eventClass = OSType(kEventClassKeyboard)
        pressedEventType.eventKind = OSType(kEventHotKeyPressed)
        InstallEventHandler(GetEventDispatcherTarget(), { _, inEvent, _ -> OSStatus in
            return HotKeyCenter.shared.sendPressedKeyboardEvent(inEvent!)
        }, 1, &pressedEventType, nil, nil)
    }

    public func sendPressedKeyboardEvent(_ event: EventRef) -> OSStatus {
        assert(Int(GetEventClass(event)) == kEventClassKeyboard, "Unknown event class")

        var hotKeyId = EventHotKeyID()
        let error = GetEventParameter(event,
                                      EventParamName(kEventParamDirectObject),
                                      EventParamName(typeEventHotKeyID),
                                      nil,
                                      MemoryLayout<EventHotKeyID>.size,
                                      nil,
                                      &hotKeyId)

        guard error == noErr else { return error }
        assert(hotKeyId.signature == UTGetOSTypeFromString("Magnet" as CFString), "Invalid hot key id")

        let hotKey = hotKeys.values.first(where: { $0.hotKeyId == hotKeyId.id })
        switch GetEventKind(event) {
        case EventParamName(kEventHotKeyPressed):
            hotKey?.invoke()
        default:
            assert(false, "Unknown event kind")
        }
        return noErr
    }
}

// MARK: - Double Tap Modifier Event
extension HotKeyCenter {
    public func installModifiersChangedEventHandlerIfNeeded() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.modifierEventHandler.handleModifiersEvent(with: event.modifierFlags, timestamp: event.timestamp)
        }
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event -> NSEvent? in
            self?.modifierEventHandler.handleModifiersEvent(with: event.modifierFlags, timestamp: event.timestamp)
            return event
        }
        modifierEventHandler.doubleTapped = { [weak self] tappedModifierFlags in
            self?.hotKeys.values
                .filter { $0.keyCombo.doubledModifiers }
                .filter { $0.keyCombo.modifiers == tappedModifierFlags.carbonModifiers() }
                .forEach { $0.invoke() }
        }
    }
}
