//
//  ApolloService.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 16.03.2024.
//

import Foundation
import Apollo

let apolloClient = ApolloClient(url: URL(string: "https://hub.snapshot.org/graphql")!)

class ApolloService {
    static let shared = ApolloService()

    private init() {}

    static let pageSize: Int = 20

    func fetchProposals(page: Int, space: String, completion: @escaping ([Proposal]) -> Void) {
        apolloClient.fetch(query: SnapshotSchema.GetProposalsQuery(
            offset: .init(integerLiteral: Self.pageSize * page),
            limit: .init(integerLiteral: Self.pageSize),
            space: .init(stringLiteral: space)
        )) { result in
            guard let data = try? result.get().data else {
                completion([])
                return
            }
            
            completion(data.proposals?.compactMap { $0 }.map { proposal in
                Proposal(
                    title: proposal.title,
                    description: proposal.body, 
                    voted: false,
                    author: proposal.author,
                    ends: Date(timeIntervalSince1970: TimeInterval(proposal.end)),
                    state: proposal.state.flatMap { .init(rawValue: $0) }
                )
            } ?? [])
        }
    }
}
