//
//  WalletService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Web3Modal
import CoreML
import Combine
import SwiftUI

class WalletService: ObservableObject {

    private var disposeBag = Set<AnyCancellable>()

    @Published
    var socketConnected: Bool?

    @Published
    var sessionActive: Bool?

    var currentSession: Session? {
        Web3Modal.instance.getSessions().first
    }

    var token: String? { currentSession?.accounts.first?.address }

    var shortToken: String? {
        guard let token else { return nil }
        return String(token.prefix(6)) + "..."
    }

    func logout() {
        guard let topic = currentSession?.topic else { return }
        Task {
            try? await Web3Modal.instance.disconnect(topic: topic)

        }
    }

    func configure() {
        let projectId = "a8c9ba3d40503f0e4f97518fdd1b2b71"

        let methods: Set<String> = ["eth_sendTransaction", "personal_sign", "eth_signTypedData", "eth_signTransaction"]
        let events: Set<String> = ["chainChanged", "accountsChanged"]
        let blockchains: Set<Blockchain> = [Blockchain("eip155:1")!, Blockchain("eip155:137")!]
        let namespaces: [String: ProposalNamespace] = [
            "eip155": ProposalNamespace(
                chains: blockchains,
                methods: methods,
                events: events
            )
        ]

        let defaultSessionParams = SessionParams(
            requiredNamespaces: namespaces,
            optionalNamespaces: nil,
            sessionProperties: nil
        )

        let metadata = AppMetadata(
            name: "Web3Modal Swift Dapp",
            description: "Web3Modal DApp sample",
            url: "www.confidenti.io",
            icons: ["https://avatars.githubusercontent.com/u/37784886"],
            redirect: .init(native: "w3mdapp://", universal: nil)
        )

        Networking.configure(
            groupIdentifier: "group.com.walletconnect.web3modal",
            projectId: projectId,
            socketFactory: DefaultSocketFactory()
        )

        Web3Modal.configure(
            projectId: projectId,
            metadata: metadata,
            sessionParams: defaultSessionParams,
            customWallets: [
                .init(
                     id: "swift-sample",
                     name: "Swift Sample Wallet",
                     homepage: "https://walletconnect.com/",
                     imageUrl: "https://avatars.githubusercontent.com/u/37784886?s=200&v=4",
                     order: 1,
                     mobileLink: "walletapp://"
                 )
            ]
        ) { error in
            print(error)
        }

        Web3Modal.instance.socketConnectionStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                print("Socket connection status: \(status)")

                self?.socketConnected = (status == .connected)
            }.store(in: &disposeBag)

        Web3Modal.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                withAnimation {
                    self?.sessionActive = (self?.currentSession != nil)
                }
            }.store(in: &disposeBag)

        if currentSession != nil {
            sessionActive = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { [weak self] in
                    guard let self else { return }
                    if sessionActive == nil {
                        sessionActive = false
                    }
                }
            }
        }

        Web3Modal.instance.logger.setLogging(level: .debug)
    }

    enum SignError: Error {
        case noAddress
        case noString
    }

    func requestWalletSign(message: String) async throws -> Data {
        guard let address = Web3Modal.instance.getAddress() else { throw SignError.noAddress }

        try await Web3Modal.instance.request(.personal_sign(address: address, message: message))

        var cancellable: AnyCancellable?
        
        defer {
            if let cancellable {
                disposeBag.remove(cancellable)
            }
        }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, any Error>) in
            cancellable = Web3Modal.instance.sessionResponsePublisher
                .receive(on: DispatchQueue.main)
                .sink { response in
                    guard let string = try? response.asJSONEncodedString() else {
                        continuation.resume(throwing: SignError.noString)
                        return
                    }
                    continuation.resume(returning: String(string.dropFirst(2)).hexData)
                }
            cancellable?.store(in: &disposeBag)
        }
    }
}
