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

    init(walletService: WalletService) {
        self.walletService = walletService

        loadQuestions { questions in
            withAnimation {
                self.questions = questions
            }
        }
    }

    func loadQuestions(completion: @escaping ([DelegatorQuestion]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion([
                .init(title: "First questions", answers: [ "One", "Two", "33" ]),
                .init(title: "2 questions", answers: [ "1", "Two", "3" ]),
                .init(title: "33 questions", answers: [ "One", "2", "333" ]),
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
