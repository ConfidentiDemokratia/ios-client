//
//  BlockchainService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import Foundation

class BlockchainService {
    static let shared = BlockchainService()

    private init() {}

    func getProposalVote(proposal: Proposal, completion: @escaping (ProposalVote) -> Void) {
        // TODO: load proposal vote
        completion(.yes)
    }

    func setProposalVote(proposal: Proposal, completion: @escaping () -> Void) {
        // TODO: apply proposal.vote
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
}
