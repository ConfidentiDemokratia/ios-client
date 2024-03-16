//
//  DaoDetails.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

struct DaoDetails: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String
    let description: String
    let space: String
}
