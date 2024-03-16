//
//  DaoAuthService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import Foundation
import SwiftUI

class DaoAuthService: ObservableObject {
    @Published
    var isAuthorized: Bool = false

    @MainActor
    func authorize() async throws {
        withAnimation {
            self.isAuthorized = true
        }
    }
}
