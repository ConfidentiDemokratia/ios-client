//
//  DaoDetailsView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI
import ButtonKit

struct DaoDetailsView: View {
    @StateObject var viewModel: DaoDetailsViewModel

    @EnvironmentObject var walletService: WalletService

    @StateObject var daoAuthService: DaoAuthService

    func proposalView(_ proposal: Proposal?) -> some View {
        NavigationLink(value: proposal) {
            VStack(alignment: .leading) {
                switch proposal?.state {
                case .active:
                    Text("active")
                        .font(.caption)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .background(.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                case .closed:
                    Text("closed")
                        .font(.caption)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .background(.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                case nil:
                    EmptyView()
                }

                if let title = proposal?.title {
                    Text(title).font(.title2)
                        .padding(.top, 2)
                }

                if let author = proposal?.author.suffix(6) {
                    Text("Authored \(author)").font(.caption)
                        .padding(.top, 2)
                }
            }
        }
        .opacity(proposal?.voted == true ? 0.8 : 1.0)
        .skeletonCell(with: !viewModel.isProposalsLoaded)
    }

    var proposalListContent: some View {
        Group {
            Section {
                ForEach(viewModel.proposals, id: \.self) { proposal in
                    proposalView(proposal)
                }
            } header: {
                Text("Proposals")
                    .skeleton(with: !viewModel.isProposalsLoaded)
            }
            
            if let _ = viewModel.page {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onAppear {
                        viewModel.loadMoreProposals()
                    }
            }
        }
    }

    var daoAuthButton: some View {
        AsyncButton {
            try await daoAuthService.authorize()
        } label: {
            Text("Authenticate").frame(maxWidth: .infinity)
        }
        .disabledWhenLoading()
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding(.bottom, 8)
        .padding(.horizontal, 14)
    }

    var content: some View {
        List {
            Text(viewModel.daoDetails?.description)
                .font(.title2)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .skeletonCell(with: !viewModel.isDaoDetailsLoaded, long: true)

            if daoAuthService.isAuthorized {
                proposalListContent
            }
        }
    }

    var body: some View {
        content
            .navigationDestination(for: Proposal.self) { proposal in
                ProposalView(viewModel: .init(proposal: proposal))
            }
            .navigationTitle(viewModel.daoDetails?.title ?? "")
            .overlay(alignment: .bottom) {
                if !daoAuthService.isAuthorized {
                    daoAuthButton
                }
            }
    }
}

#Preview {
    DaoDetailsView(viewModel: .init(daoItem: .init(title: "", description: "", logo: "", space: "")), daoAuthService: .init())
}
