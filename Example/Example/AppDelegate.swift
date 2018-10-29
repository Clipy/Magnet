//
//  AppDelegate.swift
//  Example
//
//  Created by 古林俊佑 on 2016/03/09.
//  Copyright © 2016年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa
import Magnet
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // ⌘ + Control + B
        guard let keyCombo = KeyCombo(keyCode: 11, carbonModifiers: 4352) else { return }
        let hotKey = HotKey(identifier: "CommandControlB",
                            keyCombo: keyCombo,
                            target: self,
                            action: #selector(AppDelegate.tappedHotKey))
        hotKey.register()

        // Shift + Control + A
        guard let keyCombo2 = KeyCombo(keyCode: 0, cocoaModifiers: [.shift, .control]) else { return }
        let hotKey2 = HotKey(identifier: "ShiftControlA",
                             keyCombo: keyCombo2,
                             target: self,
                             action: #selector(AppDelegate.tappedHotKey2))
        hotKey2.register()

        //　⌘　Double Tap
        guard let keyCombo3 = KeyCombo(doubledCocoaModifiers: .command) else { return }
        let hotKey3 = HotKey(identifier: "CommandDoubleTap",
                             keyCombo: keyCombo3,
                             target: self,
                             action: #selector(AppDelegate.tappedDoubleCommandKey))
        hotKey3.register()

        //　Shift　Double Tap
        guard let keyCombo4 = KeyCombo(doubledCocoaModifiers: .shift) else { return }
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

