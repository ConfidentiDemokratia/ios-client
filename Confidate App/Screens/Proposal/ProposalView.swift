//
//  ProposalView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI

struct ProposalView: View {
    @StateObject var viewModel: ProposalViewModel

    @EnvironmentObject var walletService: WalletService

    @State var vote: Vote = .abstain

    enum Vote: String, Hashable, CaseIterable {
        case yes
        case abstain
        case no
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(viewModel.proposal.title).font(.title)
                Text(viewModel.proposal.description).font(.title3)
            }
            .padding(12)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Picker("", selection: $vote) {
                    ForEach(Vote.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProposalView(viewModel: .init(proposal: .init(title: "title", description: .longMock, voted: true)))
}
