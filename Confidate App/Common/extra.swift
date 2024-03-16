import Foundation
import PromiseKit
import Web3ContractABI
import UIKit
import Combine
import SwiftUI
import UIKit
import WalletConnectSign
import Web3Modal
import CryptoSwift
import BigInt
import Web3

func loadABI(named: String) -> Data? {
    guard let path = Bundle.main.path(forResource: named, ofType: "json") else {
        print("ABI file not found.")
        return nil
    }
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    } catch {
        print("Failed to load or decode ABI file: \(error)")
        return nil
    }
}


// Function to generate an array of BigUInt with 384 random values
func generateEmbeddingArray() -> [BigUInt] {
    let numberOfElements = 384
    let bitWidth = 256 // Adjust bit width as needed

    // Generate an array of 384 BigUInt elements, each with a random value
    let embeddingArray = (0..<numberOfElements).map { _ in BigUInt.randomInteger(withExactWidth: bitWidth) }

    return embeddingArray
}

// Define a function that returns a tuple containing the specified elements
func generateProofData() -> (_pA: [BigUInt], _pB: [[BigUInt]], _pC: [BigUInt], _pubSignals: [BigUInt]) {
    // pA is an array of 2 uint256 elements
    let _pA = [BigUInt(1), BigUInt(2)]

    // _pB is a 2x2 array of uint256 elements
    let _pB = [[BigUInt(3), BigUInt(4)], [BigUInt(5), BigUInt(6)]]

    // _pC is an array of 2 uint256 elements
    let _pC = [BigUInt(7), BigUInt(8)]

    // _pubSignals is an array of 1 uint256 element
    let _pubSignals = [BigUInt(9)]

    // Return all four as a tuple
    return (_pA, _pB, _pC, _pubSignals)
}

func sendMintTx(_embedding: [BigUInt], _avatarUrl: String, _pA: [BigUInt], _pB: [[BigUInt]], _pC: [BigUInt], _pubSignals: [BigUInt]) {

//    do {
//        // Assuming you have setup Web3 with the provider and connected to Polygon Mainnet
//        let web3 = Web3(rpcURL: "https://polygon-mumbai.infura.io/v3/2MBowWB1ab2XOBq84P4YwrrdQiq")
//
//        // The contract address for BUSD on Polygon
//        let contractAddress = try! EthereumAddress(hex: "0x9263BD9904bD674725dD336A1c992770Db49275d", eip55: true) // TODO - replace with real contract
//
//        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "5c3a1c43c24faea74394df62ec9cdc9911c410e19e814b43d2f41317895fa64c")
//
//        print("Loading ABI...")
//
//
//
//        guard let abiData = loadABI(named: "confidating") else {
//            fatalError("Failed to initialize the contract")
//        }
//
//        print("Loaded ABI")
//
//
//        // Decode the ABI data into an array of ABIObject
//        let abi = try JSONDecoder().decode([ABIObject].self, from: abiData)
//
//        // Initialize the DynamicContract with the ABI and address
//        let contract = DynamicContract(abi: abi, address: contractAddress, eth: web3.eth)
//
//
//        guard let createProfileMethod = contract["createProfile"] else {
//            fatalError("Failed to get the method for the contract")
//        }
//
//
//        // Define your parameters
//        // Note: they are passed in input
//
//
//        // Create the transaction call
//        // Value of optional type '((any ABIEncodable...) -> any SolidityInvocation)?' must be unwrapped to a value of type '(any ABIEncodable...) -> any SolidityInvocation'
//        let invocation = createProfileMethod(_embedding, _avatarUrl, _pA, _pB, _pC, _pubSignals)
//
//        firstly {
//            web3.eth.gasPrice()
//        }.then { gasPrice -> Promise<(EthereumQuantity, EthereumQuantity)> in
//            print("Current gas price: \(gasPrice.quantity)")
//            let noncePromise = web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
//            return noncePromise.map { nonce in (nonce, gasPrice) }
//        }
//        .then { (nonce, gasPrice) -> Promise<(EthereumQuantity, EthereumQuantity, EthereumQuantity)> in
//            print("Calculating gas cost: from - \(privateKey.address)")
//            print("Suggested gas price: \(gasPrice)")
//            let gasPrice = EthereumQuantity(quantity: 10.gwei)
//            print("Instead used gas price: \(gasPrice)")
//
//            let gasLimitPromise = invocation.estimateGas(from: privateKey.address, gas: 0, value: EthereumQuantity(quantity: 0))
//            return gasLimitPromise.map { gasLimit in (gasLimit, nonce, gasPrice) }
//
//        }
//        .then { (gasLimit, nonce, gasPrice) -> Promise<EthereumSignedTransaction> in
//
//
//
//            print("Gas Limit: \(gasLimit)")
//            print("Tx generating...")
//
//
//            guard let transaction = invocation.createTransaction(nonce: nonce, gasPrice: gasPrice, maxFeePerGas: nil, maxPriorityFeePerGas: nil, gasLimit: gasLimit, from: privateKey.address, value: EthereumQuantity(quantity: 0), accessList: [:], transactionType: .legacy) else {
//                fatalError("Failed to create TX")
//
//            }
//            let visualTx = try transaction.json()
//            print("TX To Show:")
//            print(visualTx)
//
//
//            return try transaction.sign(with: privateKey, chainId: 80001).promise
//        }.then { signedTx -> Promise<EthereumData> in
//            print("Sending TX")
//            return web3.eth.sendRawTransaction(transaction: signedTx)
//        }.done { hash in
//            print("TX Sent:")
//            print(hash)
//        }.catch { error in
//            print(error)
//        }
//    } catch {
//        print(error)
//    }

}
