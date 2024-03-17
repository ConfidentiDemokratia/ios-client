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
