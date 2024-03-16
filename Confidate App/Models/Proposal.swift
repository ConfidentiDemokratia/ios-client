//
//  Proposal.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

struct Proposal: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String
    let description: String?
    let voted: Bool
    let author: String
    let ends: Date
    let state: ProposalState?
}

enum ProposalState: String {
    case active
    case closed
}
