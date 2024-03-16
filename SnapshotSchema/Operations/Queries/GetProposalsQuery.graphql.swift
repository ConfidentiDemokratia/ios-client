// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SnapshotSchema {
  class GetProposalsQuery: GraphQLQuery {
    static let operationName: String = "GetProposals"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetProposals { proposals(first: 20, skip: 0, orderBy: "created", orderDirection: desc) { __typename id title body } }"#
      ))

    public init() {}

    struct Data: SnapshotSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SnapshotSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("proposals", [Proposal?]?.self, arguments: [
          "first": 20,
          "skip": 0,
          "orderBy": "created",
          "orderDirection": "desc"
        ]),
      ] }

      var proposals: [Proposal?]? { __data["proposals"] }

      /// Proposal
      ///
      /// Parent Type: `Proposal`
      struct Proposal: SnapshotSchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SnapshotSchema.Objects.Proposal }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", String.self),
          .field("title", String.self),
          .field("body", String?.self),
        ] }

        var id: String { __data["id"] }
        var title: String { __data["title"] }
        var body: String? { __data["body"] }
      }
    }
  }

}