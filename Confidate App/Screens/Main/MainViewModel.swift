//
//  MainViewModel.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {

    @Published
    var daoDetailsList: [DaoItem?] = .mock()

    var isDaoDetailsListLoaded: Bool {
        daoDetailsList != .mock()
    }

    init() {
        loadDaoDetailsList { list in
            withAnimation {
                self.daoDetailsList = list
            }
        }
    }

    func loadDaoDetailsList(completion: @escaping ([DaoItem]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion([
                .init(title: "One")
            ])
        }
    }
}
