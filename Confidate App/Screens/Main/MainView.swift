//
//  MainView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    @EnvironmentObject var walletService: WalletService

    var content: some View {
        List {
            Text("List of DAOs you can vote in")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

            Section {
                ForEach(viewModel.daoDetailsList, id: \.self) { data in
                    NavigationLink(value: data) {
                        Label {
                            Text(data?.title ?? "")
                        } icon: {
                            Image(data?.logo)
                                .resizable()
                                .frame(width: 34, height: 34)
                                .clipShape(Circle())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                        }
                    }
                    .skeletonCell(with: !viewModel.isDaoDetailsListLoaded)
                }
            } 
//        header: {
//                Text("DAO's").skeleton(with: !viewModel.isDaoDetailsListLoaded)
//            }
        }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Hello, \(walletService.shortToken ?? "user")!")
                .navigationDestination(for: DaoItem.self) { daoItem in
                    RootTabView(daoItem: daoItem, daoAuthService: .init(walletService: walletService))
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            walletService.logout()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
        }
    }
}

#Preview {
    MainView()
}
