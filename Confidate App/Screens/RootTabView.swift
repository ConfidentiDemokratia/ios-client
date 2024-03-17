//
//  RootTabView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var walletService: WalletService

    let daoItem: DaoItem

    var title: String {
        switch selection {
        case .proposals:
            return "Proposals"
        case .delegator:
            return "Delegator"
        }
    }

    enum Tab {
        case proposals
        case delegator
    }

    @State var selection: Tab = .proposals

    let daoAuthService: DaoAuthService

    var body: some View {
        TabView(selection: $selection) {
            if let viewModel = try? DaoDetailsViewModel(
                daoItem: daoItem,
                daoAuthService: daoAuthService
            ) {
                DaoDetailsView(
                    viewModel: viewModel,
                    daoAuthService: daoAuthService
                )
                .tabItem {
                    Label("Proposals", systemImage: "list.dash") // questionmark.bubble
                }
                .tag(Tab.proposals)
            }

            DelegatorView(viewModel: .init(walletService: walletService, daoItem: daoItem))
                .tabItem {
                    Label("Delegator", systemImage: "person.icloud")
                }
                .tag(Tab.delegator)
        }
        .navigationTitle(title)
    }
}
