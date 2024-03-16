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

    let proposal: Proposal

    @Published var vote: ProposalVote?
    @Published var canVote = true

    init(proposal: Proposal) {
        self.proposal = proposal
    }

    func selectionChanged() {
        withAnimation {
            canVote = false
        }
        sendSelection {
            withAnimation {
                self.canVote = true
            }
        }
    }

    func sendSelection(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
}
