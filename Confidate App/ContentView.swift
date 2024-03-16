//
//  ContentView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject
    var walletService: WalletService

    var body: some View {
        switch walletService.sessionActive {
        case .none:
            ProgressView()

        case .some(true):
            RootTabView()

        case .some(false):
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
