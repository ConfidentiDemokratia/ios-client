//
//  DelegatorView.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import SwiftUI
import SkeletonUI
import MarkdownUI
import ButtonKit

struct DelegatorView: View {
    @StateObject var viewModel: DelegatorViewModel

    @EnvironmentObject var walletService: WalletService

    var sectionView: some View {
        Section {
            let seq = Array(viewModel.questions.enumerated())
            ForEach(seq, id: \.element) { questionIndex, _ in
                let question = viewModel.questions[questionIndex]

                Menu {
                    let answers = question.flatMap { Array($0.answers.enumerated()) } ?? []
                    ForEach(answers, id: \.element) { index, answer in
                        let systemImage = index == viewModel.questions[questionIndex]?.answerIndex ? "checkmark" : ""
                        Button(answer, systemImage: systemImage) {
                            withAnimation {
                                viewModel.questions[questionIndex]?.answerIndex = index
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 12) {
                        Markdown(question?.title ?? "")
                            .markdownTextStyle { ForegroundColor(question?.pickedAnswer == nil ? .primary : .secondary) }
                        if let pickedAnswer = question?.pickedAnswer {
                            Markdown(pickedAnswer)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .skeletonCell(with: !viewModel.isQuestionsLoaded)
            }
        } 
//    header: {
//            Text("Questions")
//                .skeleton(with: !viewModel.isQuestionsLoaded)
//        }
    }

    var body: some View {
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
            Group {
                if viewModel.isAnswersValid {
                    if viewModel.isDataChanged {
                        AsyncButton {
                            try await viewModel.saveUserEmbedding()
                        } label: {
                            Label("Apply", systemImage: "checkmark").frame(maxWidth: .infinity)
                        }
                        .disabledWhenLoading()
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                } else {
                    AsyncButton { @MainActor in
                        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
                        withAnimation {
                            viewModel.isDataChanged = true
                            for index in viewModel.questions.indices {
                                viewModel.questions[index]?.answerIndex = viewModel.questions[index]?.answers.indices.randomElement()
                            }
                        }
                    } label: {
                        Label("Autofill", systemImage: "wand.and.stars").frame(maxWidth: .infinity)
                    }
                    .disabledWhenLoading()
                    .tint(.indigo)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 14)
        }

    }
}

#Preview {
    DelegatorView(viewModel: .init(walletService: .init(), daoItem: .init(title: "", description: "", logo: "", space: "")))
}

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
    }
}
