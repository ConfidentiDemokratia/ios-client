//
//  DaoDetails.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation

struct DaoItem: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String
    let description: String
    let logo: String
    let space: String
}
