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

        VStack {
            Spacer()

            Text("Authorization").font(.largeTitle)
            Spacer()

            Web3ModalButton()
            Web3ModalNetworkButton()
            Spacer()
        }

    }
}

#Preview {
    AuthView()
}
