//
//  View+skeletonCell.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI
import SkeletonUI

extension View {
    func skeletonCell(with isSkeleton: Bool, long: Bool = false) -> some View {
        skeleton(
            with: isSkeleton,
            lines: long ? 10 : 1
        )
        .listRowBackground(isSkeleton ? Color.clear : nil)
        .listRowInsets(isSkeleton ? EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0) : nil)
        .listRowSeparator(isSkeleton ? .hidden : .automatic)
    }
}
