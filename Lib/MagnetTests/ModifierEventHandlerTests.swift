// 
//  ModifierEventHandlerTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015 Clipy Project.
//

import Cocoa
import Foundation
import Testing
@testable import Magnet

struct ModifierEventHandlerTests {
    private let testTimeInterval = DispatchTimeInterval.milliseconds(100)
    private let testQueue = DispatchQueue(label: "com.clipy-app.Magnet")

    // MARK: - Tests
    @Test
    func doubleTapModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 2)
        #expect(tappedModifierFlags == .shift)
    }

    @Test
    func filterHandledTimestampModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        #expect(tappedModifierFlags == nil)
    }

    @Test
    func filerUnsupportModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.function], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.function], timestamp: 2)
        #expect(tappedModifierFlags == nil)
    }

    @Test
    func multiModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            #expect(tappedModifierFlags == nil)
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [.control], timestamp: 2)
        eventHandler.handleModifiersEvent(with: [], timestamp: 3)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 4)
        eventHandler.handleModifiersEvent(with: [], timestamp: 5)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 6)
        #expect(tappedModifierFlags == .shift)
    }

    @Test
    func simultaneouslyPressMultiModifierEvent() {
        let eventHandler = ModifierEventHandler(cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            #expect(tappedModifierFlags == nil)
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.shift, .control], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 1)
        eventHandler.handleModifiersEvent(with: [], timestamp: 2)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 3)
        eventHandler.handleModifiersEvent(with: [], timestamp: 4)
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 5)
        #expect(tappedModifierFlags == .shift)
    }

    @Test
    func cleanModifierEvent() async throws {
        let eventHandler = ModifierEventHandler(cleanTimeInterval: testTimeInterval, cleanQueue: testQueue)
        var tappedModifierFlags: NSEvent.ModifierFlags?
        eventHandler.doubleTapped = { flags in
            tappedModifierFlags = flags
        }
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 0)
        eventHandler.handleModifiersEvent(with: [], timestamp: 1)
        await testQueue.waitAfter(deadline: .now() + testTimeInterval + .milliseconds(1))
        eventHandler.handleModifiersEvent(with: [.shift], timestamp: 2)
        #expect(tappedModifierFlags == nil)
    }
}

private extension DispatchQueue {
    func waitAfter(deadline: DispatchTime) async {
        await withCheckedContinuation { continuation in
            asyncAfter(deadline: deadline) {
                continuation.resume()
            }
        }
    }
}

private extension DispatchTimeInterval {
  var nanoseconds: UInt64 {
      let now = DispatchTime.now()
      let later = now.advanced(by: self)
      return later.uptimeNanoseconds - now.uptimeNanoseconds
  }
}
