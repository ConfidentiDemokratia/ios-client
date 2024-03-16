//
//  Delegator.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

struct DelegatorQuestion: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let answers: [String]
    var answerIndex: Int?
}
