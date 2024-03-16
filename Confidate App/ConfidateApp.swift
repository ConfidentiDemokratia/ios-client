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

        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
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

func generateRandomBytes() -> Data {

        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            print("Problem generating random bytes")
            fatalError()
        }
    }
