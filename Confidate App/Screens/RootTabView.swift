//
//  RootTabView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "list.dash")
                }

            DelegatorView()
                .tabItem {
                    Label("Delegator", systemImage: "person.icloud")
                }
        }
    }
}
