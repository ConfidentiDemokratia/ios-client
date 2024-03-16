//
//  AuthView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import Web3Modal

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Web3ModalButton()

                Web3ModalNetworkButton()
            }
            .navigationTitle("Authorization")
        }
    }
}

#Preview {
    AuthView()
}
