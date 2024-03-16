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
//            Text("Here you can see list of your DAOs").font(.title2)
//                .listRowInsets(EdgeInsets())
//                .listRowBackground(Color.clear)

            Section {
                ForEach(viewModel.daoDetailsList, id: \.self) { data in
                    NavigationLink(data?.title ?? "", value: data)
                        .skeletonCell(with: !viewModel.isDaoDetailsListLoaded)
                }
            } header: {
                Text("DAO's").skeleton(with: !viewModel.isDaoDetailsListLoaded)
            }
        }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Hello, \(walletService.shortToken ?? "user")!")
                .navigationDestination(for: DaoItem.self) { daoDetails in
                    DaoDetailsView(viewModel: .init(
                        daoId: daoDetails.id, 
                        title: daoDetails.title
                    ))
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
