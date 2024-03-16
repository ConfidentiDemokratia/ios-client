//
//  SkeletonWrapped.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

//enum SkeletonWrapped<T: Hashable & Identifiable>: Hashable, Identifiable {
//    var id: Self { self }
//
//    case skeleton
//    case loaded(T)
//
//    var isSkeleton: Bool {
//        switch self {
//        case .skeleton:
//            return true
//        case .loaded:
//            return false
//        }
//    }
//
//    var unwrapped: T? {
//        switch self {
//        case .skeleton:
//            return nil
//        case .loaded(let t):
//            return t
//        }
//    }
//}
//
extension Array {
    static func mock<T>() -> [T?] where Element == T? {
        .init(repeating: nil, count: 6)
    }
}
