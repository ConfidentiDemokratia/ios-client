//
//  DelegatorView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI
import ButtonKit

struct DelegatorView: View {
    @StateObject var viewModel: DelegatorViewModel

    @EnvironmentObject var walletService: WalletService

    var sectionView: some View {
        Section {
            let seq = Array(viewModel.questions.enumerated())
            ForEach(seq, id: \.element) { questionIndex, _ in
                let question = viewModel.questions[questionIndex]
                let selection = Binding($viewModel.questions[questionIndex])?.answerIndex ?? .constant(0)
                Picker(question?.title ?? "", selection: selection) {
                    Text("Not answered").tag(Optional<Int>(nil))
                    let answers = question.flatMap { Array($0.answers.enumerated()) } ?? []
                    ForEach(answers, id: \.element) { index, answer in
                        Text(answer).tag(Int?.some(index))
                    }
                }
                .pickerStyle(.menu)
                .skeletonCell(with: !viewModel.isQuestionsLoaded)
            }
        } header: {
            Text("Questions")
                .skeleton(with: !viewModel.isQuestionsLoaded)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Text("Setup your delegator for Arbitrum")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)

                sectionView

                Spacer(minLength: 48)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            .overlay(alignment: .bottom) {
                AsyncButton {
                    try await viewModel.saveUserEmbedding()
                } label: {
                    Label("Apply", systemImage: "checkmark").frame(maxWidth: .infinity)
                }
                .disabledWhenLoading()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!viewModel.isAnswersValid)
                .padding(.bottom, 8)
                .padding(.horizontal, 14)
            }
            .navigationTitle("Delegator")
        }
    }
}

#Preview {
    DelegatorView(viewModel: .init(walletService: .init()))
}
