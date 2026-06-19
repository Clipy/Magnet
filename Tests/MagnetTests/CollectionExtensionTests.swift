// 
//  CollectionExtensionTests.swift
//
//  MagnetTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015 Clipy Project.
//

import Testing
@testable import Magnet

struct CollectionExtensionTests {
    @Test
    func trueCount() {
        #expect([Bool]().trueCount == 0)
        #expect([true].trueCount == 1)
        #expect([false].trueCount == 0)
        #expect([true, true].trueCount == 2)
        #expect([true, false].trueCount == 1)
        #expect([false, false].trueCount == 0)
        #expect([false, true, false, true].trueCount == 2)
    }
}
