//
//  ProposalViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

enum ProposalVote: String, Hashable, CaseIterable {
    case yes
    case abstain
    case no
}

class ProposalViewModel: ObservableObject {

    @Published
    var proposal: Proposal

    @Published var canVote = false

    @Published var highlightedVote: ProposalVote?

    let blockchainService: BlockchainService

    init(proposal: Proposal, blockchainService: BlockchainService) {
        self.proposal = proposal
        self.blockchainService = blockchainService

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation { [weak self] in
                self?.canVote = true
                self?.highlightedVote = .yes
            }
        }
    }

    func sendSelection(completion: @escaping () -> Void) {
        withAnimation {
            canVote = false
        }
        blockchainService.setProposalVote(proposal: proposal) {
            withAnimation {
                self.canVote = true
            }
        }
    }
}
