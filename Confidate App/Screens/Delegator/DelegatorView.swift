//
//  DelegatorView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI

struct DelegatorView: View {
    @StateObject var viewModel = DelegatorViewModel()

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
                Text("Setup your delegator for Arbitrum").font(.title)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)

                sectionView
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {

                    } label: {
                        Label("Apply", systemImage: "checkmark").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(!viewModel.isAnswersValid)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Delegator")
        }
    }
}

#Preview {
    DelegatorView(viewModel: .init())
}
