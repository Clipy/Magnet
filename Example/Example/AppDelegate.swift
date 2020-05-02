//
//  AppDelegate.swift
//
//  Example
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Magnet
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // ⌘ + Control + B
        guard let keyCombo = KeyCombo(key: .b, cocoaModifiers: [.command, .control]) else { return }
        let hotKey = HotKey(identifier: "CommandControlB",
                            keyCombo: keyCombo,
                            target: self,
                            action: #selector(AppDelegate.tappedHotKey))
        hotKey.register()

        // Shift + Control + A
        guard let keyCombo2 = KeyCombo(key: .a, cocoaModifiers: [.shift, .control]) else { return }
        let hotKey2 = HotKey(identifier: "ShiftControlA",
                             keyCombo: keyCombo2,
                             target: self,
                             action: #selector(AppDelegate.tappedHotKey2))
        hotKey2.register()

        // ⌘　Double Tap
        guard let keyCombo3 = KeyCombo(doubledCocoaModifiers: .command) else { return }
        let hotKey3 = HotKey(identifier: "CommandDoubleTap",
                             keyCombo: keyCombo3,
                             target: self,
                             action: #selector(AppDelegate.tappedDoubleCommandKey))
        hotKey3.register()

        //　Shift　Double Tap
        guard let keyCombo4 = KeyCombo(doubledCarbonModifiers: shiftKey) else { return }
        let hotKey4 = HotKey(identifier: "ShiftDoubleTap",
                             keyCombo: keyCombo4,
                             target: self,
                             action: #selector(AppDelegate.tappedDoubleShiftKey))
        hotKey4.register()

        //　Control　Double Tap
        guard let keyCombo5 = KeyCombo(doubledCocoaModifiers: .control) else { return }
        let hotKey5 = HotKey(identifier: "ControlDoubleTap", keyCombo: keyCombo5) { _ in
            print("control double tapped!!!")
        }
        hotKey5.register()

        //　Option　Double Tap
        guard let keyCombo6 = KeyCombo(doubledCocoaModifiers: .option) else { return }
        let hotKey6 = HotKey(identifier: "OptionDoubleTap", keyCombo: keyCombo6) { _ in
            print("option double tapped!!!")
        }
        hotKey6.register()
    }

    @objc func tappedHotKey() {
        print("hotKey!!!!")
    }

    @objc func tappedHotKey2() {
        print("hotKey2!!!!")
    }

    @objc func tappedDoubleCommandKey() {
        print("command double tapped!!!")
    }

    @objc func tappedDoubleShiftKey() {
        print("shift double tapped!!!")
    }
}
