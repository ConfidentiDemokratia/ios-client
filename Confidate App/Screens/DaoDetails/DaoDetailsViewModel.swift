//
//  DaoDetailsViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

class DaoDetailsViewModel: ObservableObject {

    let daoId: UUID
    let title: String?
    @Published var daoDetails: DaoDetails?
    @Published var proposals: [Proposal?] = .mock()

    var isDaoDetailsLoaded: Bool {
        daoDetails != nil
    }

    var isProposalsLoaded: Bool {
        proposals != .mock()
    }

    init(daoId: UUID, title: String?) {
        self.daoId = daoId
        self.title = title

        loadProposals { proposals in
            withAnimation {
                self.proposals = proposals
            }
        }

        loadDaoDetails { daoDetails in
            withAnimation {
                self.daoDetails = daoDetails
            }
        }
    }

    func loadDaoDetails(completion: @escaping (DaoDetails) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.init(title: "Title", description: .longMock))
        }
    }

    func loadProposals(completion: @escaping ([Proposal]) -> Void) {
        ApolloService.shared.fetchProposals {
            completion($0)
        }
    }

}
