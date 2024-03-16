//
//  Confidate_AppApp.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Combine
import SwiftUI
import Web3Modal

@main
struct ConfidateApp: App {
    var walletService = WalletService()

    init() {
        walletService.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(walletService)
                .onOpenURL { url in
                    Web3Modal.instance.handleDeeplink(url)
                }
        }
    }
}
