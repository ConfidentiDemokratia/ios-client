//
//  UISegmentedControl++.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import UIKit

extension UISegmentedControl {
  override open func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.setContentHuggingPriority(.defaultLow, for: .vertical)
   }
}
