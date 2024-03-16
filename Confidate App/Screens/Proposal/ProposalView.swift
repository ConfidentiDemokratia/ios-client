//
//  ProposalView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import MarkdownUI

struct ProposalView: View {
    @StateObject var viewModel: ProposalViewModel

    @EnvironmentObject var walletService: WalletService

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(viewModel.proposal.title).font(.title)
                if let description = viewModel.proposal.description {
                    Markdown(description)
                } else {
                    Text("No description here...").font(.title3).disabled(true)
                }
            }
            .padding(12)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Picker("", selection: $viewModel.proposal.vote) {
                        ForEach(ProposalVote.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag(Optional<ProposalVote>($0))
                        }
                    }
                    .frame(height: 32)
                    .pickerStyle(.segmented)
                    .scaledToFill()
                    .padding(.horizontal, 24)
                    .scaleEffect(CGSize(width: 1.2, height: 1.2))
                    .disabled(!viewModel.canVote)
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .onChange(of: viewModel.proposal.vote) {
            viewModel.sendSelection {
                dismiss()
            }
        }
    }
}

#Preview {
    ProposalView(viewModel: .init(proposal: .init(id: "", title: "", description: nil, vote: nil, author: "", ends: .init(), state: .active)))
}
