//
//  DelegatorViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI
import CoreML

class DelegatorViewModel: ObservableObject {

    @Published var questions: [DelegatorQuestion?] = .mock()

    let walletService: WalletService

    var isQuestionsLoaded: Bool {
        questions != .mock()
    }

    var isAnswersValid: Bool {
        questions.allSatisfy { $0?.answerIndex != nil }
    }

    let daoItem: DaoItem

    func insertDaos(into string: String) -> String {
        string.replacingOccurrences(of: "$DAO_NAME", with: daoItem.title)
    }

    init(walletService: WalletService, daoItem: DaoItem) {
        self.walletService = walletService
        self.daoItem = daoItem

        loadQuestions { questions in
            withAnimation { [weak self] in
                guard let self else { return }
                var questions = questions

                for questionIndex in questions.indices {
                    questions[questionIndex].title = insertDaos(into: questions[questionIndex].title)
                    questions[questionIndex].answers = questions[questionIndex].answers.map { self.insertDaos(into: $0) }
                }

                self.questions = questions
            }
        }
    }

    func loadQuestions(completion: @escaping ([DelegatorQuestion]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([
                .init(
                    title: "**Governance Philosophy**: Which foundational principle should guide $DAO_NAME DAO's governance?",
                    answers: [
                        "Empowering the broader community",
                        "Focusing on swift and effective decision-making",
                        "Ensuring openness in all processes"
                    ]
                ),
                .init(
                    title: "**Voting Rights Distribution**: How should $DAO_NAME DAO allocate voting rights?",
                    answers: [
                        "One member, one vote",
                        "Votes weighted by token holding",
                        "Votes earned by active participation"
                    ]
                ),
                .init(
                    title: "**Engagement in Governance**: How should community engagement be optimised at $DAO_NAME DAO?",
                    answers: [
                        "Facilitating widespread participation",
                        "Utilising a selected panel for decision-making",
                        "Offering rewards for active involvement"
                    ]
                ),
                .init(
                    title: "**Resolving Internal Conflicts**: Which conflict resolution method is best for $DAO_NAME DAO?",
                    answers: [
                        "Using a dedicated DAO committee",
                        "Resorting to community voting",
                        "Hiring independent arbitrators"
                    ]
                ),
                .init(
                    title: "**Priority Areas for Proposal Focus**: Where should $DAO_NAME DAO focus?",
                    answers: [
                        "Concentrating on technical foundations",
                        "Building community and partnerships",
                        "Developing governance frameworks and guidelines"
                    ]
                ),
                .init(
                    title: "**Adaptation to Market Changes**: How should $DAO_NAME DAO adapt to market dynamics?",
                    answers: [
                        "Quickly responding to market dynamics",
                        "Taking measured, well-considered actions",
                        "Following a long-term vision, despite fluctuations"
                    ]
                ),
                .init(
                    title: "**Economic Model Considerations**: What should $DAO_NAME DAO’s economic focus be?",
                    answers: [
                        "Ensuring long-term viability",
                        "Boosting participation and transaction volume",
                        "Maintaining equitable distribution and access"
                    ]
                ),
                .init(
                    title: "**Technological Development Focus**: What should $DAO_NAME DAO’s technological focus be?",
                    answers: [
                        "Supporting growth and efficiency",
                        "Fortifying against threats and vulnerabilities",
                        "Enhancing user experience and accessibility"
                    ]
                ),
                .init(
                    title: "**Funding Allocation**: How should $DAO_NAME DAO’s resources be allocated?",
                    answers: [
                        "Investing in technology and platform upgrades",
                        "Supporting initiatives and engagement",
                        "Expanding awareness and adoption"
                    ]
                ),
                .init(
                    title: "**Vision for $DAO_NAME's Future**: What should $DAO_NAME DAO DAO aim for?",
                    answers: [
                        "Aspiring to be a top Layer 2 solution",
                        "Cultivating a strong, supportive ecosystem",
                        "Pioneering in technology and governance"
                    ]
                ),
            ])
        }
    }

    func convertToArray(from mlMultiArray: MLMultiArray) -> [Double] {

        // Init our output array
        var array: [Double] = []

        // Get length
        let length = mlMultiArray.count

        // Set content of multi array to our out put array
        for i in 0...length - 1 {
            array.append(Double(truncating: mlMultiArray[[0,NSNumber(value: i)]]))
        }

        return array
    }

    func saveUserEmbedding() async throws {
        let data = (try UserEmbedder().embed(questions: questions.compactMap { $0 })) ?? .init()

//        let testData = generateRandomBytes()
//        let data = hashEmbedding(embedding: testData)

        guard let address = walletService.shortToken else { fatalError() }

        let result = try await DelegatorService.shared.saveUserEmbedding(
            .init(address: address, user_embedding: convertToArray(from: data))
        )

        debugPrint("SUCCESS")
    }
}
