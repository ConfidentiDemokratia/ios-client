//
//  UINavigationController+removeBackButtonTitle.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
