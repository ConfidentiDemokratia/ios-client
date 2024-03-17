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

    var publicKey: Data?

    let daoAddress: EthereumAddress
    let daoAuthService: DaoAuthService

    init(
        daoAddress: String? = nil,
        daoAuthService: DaoAuthService
    ) throws {
        self.daoAddress = try EthereumAddress(hex: daoAddress ?? daoAddressStr, eip55: true)
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

        guard let abiData = loadABI(named: "maciABI") else {
            fatalError("Failed to initialize the contract")
        }

        print("Loaded ABI")

        // Decode the ABI data into an array of ABIObject
        let abi = try JSONDecoder().decode([ABIObject].self, from: abiData)

        // Initialize the DynamicContract with the ABI and address
        return DynamicContract(abi: abi, address: contractAddress, eth: Self.web3.eth)
    }
    

    func getProposalVote(
        completion: @escaping (ProposalVote) -> Void
    ) {
        do {
            let contract = try getContract(contractAddress: daoAddress, name: "maciABI")

            firstly {
                guard let getNextPollIdMethod = contract["nextPollId"] else {
                    fatalError("Failed to get the method for the getPollsMethod")
                }

                guard let getPubkeyMethod = contract["coordinatorPubkey"] else {
                    fatalError("Failed to get the method for the get delegatorVotes")
                }

                return when(fulfilled:
                    getNextPollIdMethod().call()
                        .compactMap { values in
                            if let pollId = values[""] as? BigUInt {
                                return pollId - BigUInt(1)
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
                        .then { (pollAddress: EthereumAddress) -> Promise<[String: Any]> in
                            let contract = try self.getContract(contractAddress: pollAddress, name: "pollABI")

                            guard let getDelegatorVotesMethod = contract["delegatorVotes"] else {
                                fatalError("Failed to get the method for the get delegatorVotes")
                            }

                            return getDelegatorVotesMethod(Self.wallletPrivateKey.address).call()
                        }
                        .compactMap { values -> BigUInt? in
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
}
