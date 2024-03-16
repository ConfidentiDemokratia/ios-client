//
//  DaoDetailsView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI

struct DaoDetailsView: View {
    @StateObject var viewModel: DaoDetailsViewModel

    @EnvironmentObject var walletService: WalletService

    var content: some View {
        List {
            Section {
                Text(viewModel.daoDetails?.description)
                    .font(.title2)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .skeletonCell(with: !viewModel.isDaoDetailsLoaded, long: true)
            }

            Section {
                ForEach(viewModel.proposals, id: \.self) { proposal in
                    NavigationLink(proposal?.title ?? viewModel.title ?? "", value: proposal)
                        .opacity(proposal?.voted == true ? 0.8 : 1.0)
                        .skeletonCell(with: !viewModel.isProposalsLoaded)
                }
            } header: { 
                Text("Proposals")
                    .skeleton(with: !viewModel.isProposalsLoaded)
            }
        }
    }

    var body: some View {
        content
            .navigationDestination(for: Proposal.self) { proposal in
                ProposalView(viewModel: .init(proposal: proposal))
            }
            .navigationTitle(viewModel.daoDetails?.title ?? "")
    }
}

#Preview {
    DaoDetailsView(viewModel: .init(daoId: .init(), title: "test"))
}
