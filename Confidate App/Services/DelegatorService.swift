//
//  DelegatorService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import Foundation

class DelegatorService {
    static let shared = DelegatorService()

    private init() {}

    static let baseUrl = URL(string: "http://165.22.115.171:80/")!

    struct UserEmbedding: Encodable {
        let address: String
        let user_embedding: [Double]
    }

    func saveUserEmbedding(_ userEmbedding: UserEmbedding) async throws {
        var request = URLRequest(url: Self.baseUrl.appending(component: "save_user_embedding"))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(userEmbedding)

        let result = try await URLSession.shared.data(
            for: request
        )

        debugPrint("")
    }
}
