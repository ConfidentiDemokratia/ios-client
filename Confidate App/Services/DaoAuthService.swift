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

    let walletService: WalletService

    var privateKey: Data?
    var publicKey: Data?

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    @MainActor
    func authorize() async throws {
        let signed = try await walletService.requestWalletSign(message: "MACI")

        let mergedKey = extGenerateKeys(signedBytes: signed)

        if mergedKey.count != 96 {
            debugPrint("mergedKey.count != 96!!!")
        }
        privateKey = mergedKey.prefix(32)
        publicKey = mergedKey.suffix(64)

        withAnimation {
            self.isAuthorized = true
        }
    }
}
