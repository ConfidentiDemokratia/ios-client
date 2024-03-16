//
//  ProposalViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

class ProposalViewModel: ObservableObject {

    let proposal: Proposal

    init(proposal: Proposal) {
        self.proposal = proposal
    }

}
