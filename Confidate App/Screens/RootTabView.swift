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

    var body: some View {
        TabView(selection: $selection) {
            DaoDetailsView(
                viewModel: .init(
                    daoItem: daoItem
                ),
                daoAuthService: DaoAuthService()
            )
            .tabItem {
                Label("Proposals", systemImage: "list.dash") // questionmark.bubble
            }
            .tag(Tab.proposals)

            DelegatorView(viewModel: .init(walletService: walletService))
                .tabItem {
                    Label("Delegator", systemImage: "person.icloud")
                }
                .tag(Tab.delegator)
        }
        .navigationTitle(title)
    }
}
