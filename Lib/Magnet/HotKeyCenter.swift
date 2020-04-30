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

public final class HotKeyCenter {

    // MARK: - Properties
    public static let shared = HotKeyCenter()

    private var hotKeys = [String: HotKey]()
    private var hotKeyCount: UInt32 = 0
    private var tappedModifierKey = NSEvent.ModifierFlags(rawValue: 0)
    private var multiModifiers = false
    private var isInstalledFlagsChangedEvent = false
    private let notificationCenter: NotificationCenter

    // MARK: - Initialize
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        installHotKeyPressedEventHandler()
        observeApplicationTerminate()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

}

// MARK: - Register & Unregister
public extension HotKeyCenter {
    @discardableResult
    func register(with hotKey: HotKey) -> Bool {
        guard !hotKeys.keys.contains(hotKey.identifier) else { return false }
        guard !hotKeys.values.contains(hotKey) else { return false }

        hotKeys[hotKey.identifier] = hotKey
        guard !hotKey.keyCombo.doubledModifiers else {
            // In the case of a double-tap shortcut, start independent monitoring
            installModifierEventHandlerIfNeeded()
            return true
        }
        // Normal macOS shortcut
        /*
         *  Discussion:
         *    When registering a hotkey, a KeyCode that conforms to the
         *    keyboard layout at the time of registration is registered.
         *    To register a `v` on the QWERTY keyboard, `9` is registered,
         *    and to register a `v` on the Dvorak keyboard, `47` is registered.
         *    Therefore, if you change the keyboard layout after registering
         *    a hot key, the hot key is not assigned to the correct key.
         *    To solve this problem, you need to re-register the hotkeys
         *    when you change the layout, but it's not supported by the
         *    Apple Genuine app either, so it's not supported now.
         */
        let hotKeyId = EventHotKeyID(signature: UTGetOSTypeFromString("Magnet" as CFString), id: hotKeyCount)
        var carbonHotKey: EventHotKeyRef?
        let error = RegisterEventHotKey(UInt32(hotKey.keyCombo.currentKeyCode),
                                        UInt32(hotKey.keyCombo.modifiers),
                                        hotKeyId,
                                        GetEventDispatcherTarget(),
                                        0,
                                        &carbonHotKey)
        if error != 0 {
            unregister(with: hotKey)
            return false
        }
        hotKey.hotKeyId = hotKeyId.id
        hotKey.hotKeyRef = carbonHotKey
        hotKeyCount += 1

        return true
    }

    func unregister(with hotKey: HotKey) {
        if let carbonHotKey = hotKey.hotKeyRef {
            UnregisterEventHotKey(carbonHotKey)
        }
        hotKeys.removeValue(forKey: hotKey.identifier)
        hotKey.hotKeyId = nil
        hotKey.hotKeyRef = nil
    }

    @discardableResult
    func unregisterHotKey(with identifier: String) -> Bool {
        guard let hotKey = hotKeys[identifier] else { return false }
        unregister(with: hotKey)
        return true
    }

    func unregisterAll() {
        hotKeys.forEach { unregister(with: $1) }
    }
}

// MARK: - Terminate
extension HotKeyCenter {
    private func observeApplicationTerminate() {
        notificationCenter.addObserver(self,
                                       selector: #selector(HotKeyCenter.applicationWillTerminate),
                                       name: NSApplication.willTerminateNotification,
                                       object: nil)
    }

    @objc func applicationWillTerminate() {
        unregisterAll()
    }
}

// MARK: - HotKey Events
private extension HotKeyCenter {
    func installHotKeyPressedEventHandler() {
        var pressedEventType = EventTypeSpec()
        pressedEventType.eventClass = OSType(kEventClassKeyboard)
        pressedEventType.eventKind = OSType(kEventHotKeyPressed)
        InstallEventHandler(GetEventDispatcherTarget(), { _, inEvent, _ -> OSStatus in
            return HotKeyCenter.shared.sendCarbonEvent(inEvent!)
        }, 1, &pressedEventType, nil, nil)
    }

    func installModifierEventHandlerIfNeeded() {
        guard !isInstalledFlagsChangedEvent else { return }
        // Press Modifiers Event
        let mask = CGEventMask((1 << CGEventType.flagsChanged.rawValue))
        let event = CGEvent.tapCreate(tap: .cghidEventTap,
                                      place: .headInsertEventTap,
                                      options: .listenOnly,
                                      eventsOfInterest: mask,
                                      callback: { _, _, event, _ in return HotKeyCenter.shared.sendModifiersEvent(event) },
                                      userInfo: nil)
        guard let modifiersEvent = event else { return }
        isInstalledFlagsChangedEvent = true
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, modifiersEvent, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.commonModes)
        CGEvent.tapEnable(tap: modifiersEvent, enable: true)
    }

    func sendCarbonEvent(_ event: EventRef) -> OSStatus {
        assert(Int(GetEventClass(event)) == kEventClassKeyboard, "Unknown event class")

        var hotKeyId = EventHotKeyID()
        let error = GetEventParameter(event,
                                      EventParamName(kEventParamDirectObject),
                                      EventParamName(typeEventHotKeyID),
                                      nil,
                                      MemoryLayout<EventHotKeyID>.size,
                                      nil,
                                      &hotKeyId)

        if error != 0 { return error }

        assert(hotKeyId.signature == UTGetOSTypeFromString("Magnet" as CFString), "Invalid hot key id")

        let hotKey = hotKeys.values.first(where: { $0.hotKeyId == hotKeyId.id })
        switch GetEventKind(event) {
        case EventParamName(kEventHotKeyPressed):
            hotKeyDown(hotKey)
        default:
            assert(false, "Unknown event kind")
        }
        return noErr
    }

    func hotKeyDown(_ hotKey: HotKey?) {
        guard let hotKey = hotKey else { return }
        hotKey.invoke()
    }
}

// MARK: - Double Tap Modifier Event
private extension HotKeyCenter {
    func sendModifiersEvent(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        let flags = event.flags

        let commandTapped = flags.contains(.maskCommand)
        let shiftTapped = flags.contains(.maskShift)
        let controlTapped = flags.contains(.maskControl)
        let altTapped = flags.contains(.maskAlternate)

        // Only one modifier key
        let modifiersCount = [commandTapped, altTapped, shiftTapped, controlTapped].trueCount
        if modifiersCount == 0 { return Unmanaged.passUnretained(event) }
        if modifiersCount > 1 {
            multiModifiers = true
            return Unmanaged.passUnretained(event)
        }
        if multiModifiers {
            multiModifiers = false
            return Unmanaged.passUnretained(event)
        }

        if (tappedModifierKey.contains(.command) && commandTapped) ||
            (tappedModifierKey.contains(.shift) && shiftTapped)    ||
            (tappedModifierKey.contains(.control) && controlTapped) ||
            (tappedModifierKey.contains(.option) && altTapped) {
            doubleTapped(with: tappedModifierKey.carbonModifiers())
            tappedModifierKey = NSEvent.ModifierFlags(rawValue: 0)
        } else {
            if commandTapped {
                tappedModifierKey = .command
            } else if shiftTapped {
                tappedModifierKey = .shift
            } else if controlTapped {
                tappedModifierKey = .control
            } else if altTapped {
                tappedModifierKey = .option
            } else {
                tappedModifierKey = NSEvent.ModifierFlags(rawValue: 0)
            }
        }

        // Clean Flag
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: { [weak self] in
            self?.tappedModifierKey = NSEvent.ModifierFlags(rawValue: 0)
        })

        return Unmanaged.passUnretained(event)
    }

    func doubleTapped(with key: Int) {
        hotKeys.values
            .filter { $0.keyCombo.doubledModifiers && $0.keyCombo.modifiers == key }
            .forEach { $0.invoke() }
    }
}
