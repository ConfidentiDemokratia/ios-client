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

//    let service = try! BlockchainService(daoAddress: "")

    init() {
        walletService.configure()

        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true


//        guard let proposalIndex = proposals.firstIndex(of: proposal) else { return }
//        service.getProposalVote { vote in
//            debugPrint("boo")
//        }

//        let key = extGeneratePubkey(signedBytes: generateRandomBytes(count: 64))
//
//        let sign = extSignPubkey(toSign: generateRandomBytes(), prk: generateRandomBytes())

//        let prk = generateRandomBytes(count: 32)
//        let pbk = generateRandomBytes(count: 64)
//        let expected = Data.init(repeating: 1, count: 64)
//        let encrypted = encrypt(prk: prk, pbk: pbk, message: expected)
//        let actual = decrypt(prk: prk, pbk: pbk, enc: encrypted)

        
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

func generateRandomBytes(count: Int = 32) -> Data {

    var keyData = Data(count: count)
    let result = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!)
    }
    if result == errSecSuccess {
        return keyData
    } else {
        print("Problem generating random bytes")
        fatalError()
    }
}
