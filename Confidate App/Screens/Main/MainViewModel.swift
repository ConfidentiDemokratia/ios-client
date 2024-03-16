//
//  MainViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {

    @Published
    var daoDetailsList: [DaoItem?] = .mock()

    var isDaoDetailsListLoaded: Bool {
        daoDetailsList != .mock()
    }

    init() {
        loadDaoDetailsList { list in
            withAnimation {
                self.daoDetailsList = list
            }
        }
    }

    func loadDaoDetailsList(completion: @escaping ([DaoItem]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([
                .init(title: "Arbitrum", description: "The Arbitrum DAO is a decentralized autonomous organization (DAO) built on the Ethereum blockchain. At its core, the Arbitrum DAO is a community-driven governance mechanism that allows $ARB token holders to propose and vote on changes to the organization and the technologies it governs.", logo: "arbitrum", space: "arbitrumfoundation.eth"),
                .init(title: "Aave",description: "Aave Grants DAO is a community-led grants program to fund ideas submitted by the Aave protocol’s community, with a focus on empowering a wider network of community developers.", logo: "aave", space: "aave.eth"),
                .init(title: "Noun", description: """
                     One Noun, Every Day, Forever.
                         Behold, an infinite work of art! Nouns is a community-owned brand that makes a positive impact by funding ideas and fostering collaboration. From collectors and technologists, to non-profits and brands, Nouns is for everyone.
                     """, logo: "nouns", space: "pnounsdao.eth"),
                .init(title: "Optimism",description: "Optimism is an open source protocol that was developed and launched in late 2021 by a group of Ethereum developers. The protocol is governed and maintained by the Optimism Collective, a DAO comprised of a global network of interested individuals, groups, and developers.", logo: "optimism", space: "opcollective.eth"),
                .init(title: "Lido",description: "The Lido DAO is a Decentralized Autonomous Organization that decides on the key upgrades and key parameters of liquid staking protocols through the voting power of governance token (LDO) tokens.", logo: "lido", space: "lido-snapshot.eth")
            ])
        }
    }
}
