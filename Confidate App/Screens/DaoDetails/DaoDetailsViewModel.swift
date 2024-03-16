//
//  DaoDetailsViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

class DaoDetailsViewModel: ObservableObject {

    let daoItem: DaoItem
    @Published var daoDetails: DaoDetails?
    @Published var proposals: [Proposal?] = .mock()
    @Published var page: Int? = 0

    var isDaoDetailsLoaded: Bool {
        daoDetails != nil
    }

    var isProposalsLoaded: Bool {
        proposals != .mock()
    }

    init(daoItem: DaoItem) {
        self.daoItem = daoItem

        loadMoreProposals()

        loadDaoDetails { daoDetails in
            withAnimation {
                self.daoDetails = daoDetails
            }
        }
    }

    func loadMoreProposals() {
        loadProposals { proposals in
            withAnimation { [weak self] in
                guard let self else { return }
                if isProposalsLoaded {
                    self.proposals += proposals
                } else {
                    self.proposals = proposals
                }
            }
        }
    }

    func loadDaoDetails(completion: @escaping (DaoDetails) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.init(title: self.daoItem.title ?? "", description: .longMock, space: ""))
        }
    }

    func loadProposals(completion: @escaping ([Proposal]) -> Void) {
        guard let page else {
            completion([])
            return
        }
        ApolloService.shared.fetchProposals(page: page, space: daoItem.space ?? "") { proposals in
            completion(proposals)
            withAnimation {
                self.page = proposals.isEmpty ? nil : page + 1
            }
        }

    }

}
