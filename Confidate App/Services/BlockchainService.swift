//
//  BlockchainService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import Foundation
import BigInt
import Web3
import Web3ContractABI
import Web3PromiseKit
import Web3ContractABI

class BlockchainService {
    // Assuming you have setup Web3 with the provider and connected to Polygon Mainnet
    static let web3 = Web3(rpcURL: rpcURL)
    static let wallletPrivateKey: EthereumPrivateKey = try! EthereumPrivateKey(hexPrivateKey: walletPrivateKey)
    static let chainId: EthereumQuantity = 421614

    var publicKey: Data?

    let daoAddress: EthereumAddress
    let daoAuthService: DaoAuthService

    init(
        daoAddress: String,
        daoAuthService: DaoAuthService
    ) throws {
        self.daoAddress = try EthereumAddress(hex: daoAddress, eip55: true)
        self.daoAuthService = daoAuthService
    }

    func getProposalVote(proposal: Proposal, completion: @escaping (ProposalVote) -> Void) {
        getProposalVote(completion: completion)
    }

    func setProposalVote(proposal: Proposal, completion: @escaping () -> Void) {
        // TODO: apply proposal.vote
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }

    private func getContract(
        contractAddress: EthereumAddress,
        name: String
    ) throws -> DynamicContract {
        print("Loading ABI...")

        guard let abiData = loadABI(named: name) else {
            fatalError("Failed to initialize the contract")
        }

        print("Loaded ABI")

        // Decode the ABI data into an array of ABIObject
        let abi = try JSONDecoder().decode([ABIObject?].self, from: abiData)

        // Initialize the DynamicContract with the ABI and address
        return DynamicContract(abi: abi.compactMap { $0 }, address: contractAddress, eth: Self.web3.eth)
    }

    func getProposalVote(
        completion: @escaping (ProposalVote) -> Void
    ) {
        do {
            let contract = try getContract(contractAddress: daoAddress, name: "maciABI")

            guard let getNextPollIdMethod = contract["nextPollId"] else {
                fatalError("Failed to get the method for the getPollsMethod")
            }

            firstly {
                getNextPollIdMethod().call()
                    .compactMap { values in
                        if let pollId = values[""] as? BigUInt {
                            return pollId // TODO: - BigUInt(1) handle 0
                        }
                        return nil
                    }
                    .then { (pollId: BigUInt) -> Promise<[String: Any]> in
                        guard let getPollMethod = contract["polls"] else {
                            fatalError("Failed to get the method for the getPoll")
                        }

                        return getPollMethod((pollId)).call()
                    }
                    .compactMap { values in
                        if let address = values[""] as? EthereumAddress {
                            return address
                        }
                        return nil
                    }
                    .then { (pollAddress: EthereumAddress) -> Promise<Promise<(BigUInt, BigUInt)>.T> in
                        let contract = try self.getContract(contractAddress: pollAddress, name: "pollABI")

                        guard let getDelegatorVotesMethod = contract["delegatorVotes"] else {
                            fatalError("Failed to get the method for the get delegatorVotes")
                        }

                        guard let getPubkeyMethod = contract["coordinatorPubKey"] else {
                            fatalError("Failed to get the method for the get delegatorVotes")
                        }

                        return firstly {
                            when(
                                fulfilled: getDelegatorVotesMethod(Self.wallletPrivateKey.address).call()
                                    .compactMap { (values) -> BigUInt? in
                                        if let address = values["encVote"] as? BigUInt, // TODO: convert to BigUInt[2]
                                            let hasPersonallyVoted = values["hasPersonallyVoted"] as? BigUInt {
                                            if hasPersonallyVoted == .init(0) {
                                                return nil
                                            } else {
                                                return address
                                            }
                                        }
                                        return nil
                                    },
                                getPubkeyMethod().call()
                                    .compactMap { values -> BigUInt? in
                                        if let pubKey = values[""] as? BigUInt {
                                            return pubKey
                                        }
                                        return nil
                                    }
                            )
                        }
                    }
            }
            .done { [weak self] (address: BigUInt, pbk: BigUInt) in

                guard let self, let prk = self.daoAuthService.privateKey else {
                    fatalError("Failed to find prk")
                }

                decrypt(prk: prk, pbk: try Data(pbk), enc: try Data(address))

                // TODO: parse vote
            }
            .catch { error in
                print(error)
                fatalError()
            }

        } catch {
            print(error)
            fatalError()
        }
    }

    func uploadPublicKey(_ publicKey: Data) {
        do {
            // Initialize the DynamicContract with the ABI and address
            let contract = try getContract(contractAddress: daoAddress, name: "maciABI")

            guard let createProfileMethod = contract["signUp"] else {
                fatalError("Failed to get the method for the sign up")
            }

            let tuple = SolidityTuple([
                .init(value: BigUInt(publicKey.prefix(32)), type: .uint256),
                .init(value: BigUInt(publicKey.suffix(32)), type: .uint256),
            ])
            let invocation = createProfileMethod(tuple)

            firstly {
                Self.web3.eth.gasPrice()
            }.then { gasPrice -> Promise<(EthereumQuantity, EthereumQuantity)> in
                print("Current gas price: \(gasPrice.quantity)")
                let noncePromise = Self.web3.eth.getTransactionCount(address: Self.wallletPrivateKey.address, block: .latest)
                return noncePromise.map { nonce in (nonce, gasPrice) }
            }
            .then { (nonce, gasPrice) -> Promise<(EthereumQuantity, EthereumQuantity, EthereumQuantity)> in
//                print("Calculating gas cost: from - \(Self.wallletPrivateKey.privateKey.address)")
                print("Suggested gas price: \(gasPrice)")
                let gasPrice = EthereumQuantity(quantity: 10.gwei)
                print("Instead used gas price: \(gasPrice)")

                let gasLimitPromise = invocation.estimateGas(from: Self.wallletPrivateKey.address, gas: 0, value: EthereumQuantity(quantity: 0))
                return gasLimitPromise.map { gasLimit in (gasLimit, nonce, gasPrice) }

            }
            .then { (gasLimit, nonce, gasPrice) -> Promise<EthereumSignedTransaction> in



                print("Gas Limit: \(gasLimit)")
                print("Tx generating...")


                guard let transaction = invocation.createTransaction(nonce: nonce, gasPrice: gasPrice, maxFeePerGas: nil, maxPriorityFeePerGas: nil, gasLimit: gasLimit, from: Self.wallletPrivateKey.address, value: EthereumQuantity(quantity: 0), accessList: [:], transactionType: .legacy) else {
                    fatalError("Failed to create TX")

                }
                let visualTx = try transaction.json()
                print("TX To Show:")
                print(visualTx)


                return try transaction.sign(with: Self.wallletPrivateKey, chainId: Self.chainId).promise
            }.then { signedTx -> Promise<EthereumData> in
                print("Sending TX")
                return Self.web3.eth.sendRawTransaction(transaction: signedTx)
            }.done { hash in
                print("TX Sent:")
                print(hash)
            }.catch { error in
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
