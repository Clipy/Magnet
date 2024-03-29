// 
//  CollectionExtension.swift
//
//  Magnet
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

#if os(macOS)
import Foundation

public extension Collection where Element == Bool {
    var trueCount: Int {
        return filter { $0 }.count
    }
}
#endif
