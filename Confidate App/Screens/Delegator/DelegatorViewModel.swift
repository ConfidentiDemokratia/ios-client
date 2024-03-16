//
//  DelegatorViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

class DelegatorViewModel: ObservableObject {

    @Published var questions: [DelegatorQuestion?] = .mock()

    var isQuestionsLoaded: Bool {
        questions != .mock()
    }

    var isAnswersValid: Bool {
        questions.allSatisfy { $0?.answerIndex != nil }
    }

    init() {
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
}
