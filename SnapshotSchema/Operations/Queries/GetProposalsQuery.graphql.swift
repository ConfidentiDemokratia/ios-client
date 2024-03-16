// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SnapshotSchema {
  class GetProposalsQuery: GraphQLQuery {
    static let operationName: String = "GetProposals"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetProposals($offset: Int, $limit: Int, $space: String) { proposals( first: $limit skip: $offset where: { space_in: [$space] } orderBy: "created" orderDirection: desc ) { __typename id title body state author end } }"#
      ))

    public var offset: GraphQLNullable<Int>
    public var limit: GraphQLNullable<Int>
    public var space: GraphQLNullable<String>

    public init(
      offset: GraphQLNullable<Int>,
      limit: GraphQLNullable<Int>,
      space: GraphQLNullable<String>
    ) {
      self.offset = offset
      self.limit = limit
      self.space = space
    }

    public var __variables: Variables? { [
      "offset": offset,
      "limit": limit,
      "space": space
    ] }

    struct Data: SnapshotSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SnapshotSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("proposals", [Proposal?]?.self, arguments: [
          "first": .variable("limit"),
          "skip": .variable("offset"),
          "where": ["space_in": [.variable("space")]],
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
          .field("state", String?.self),
          .field("author", String.self),
          .field("end", Int.self),
        ] }

        var id: String { __data["id"] }
        var title: String { __data["title"] }
        var body: String? { __data["body"] }
        var state: String? { __data["state"] }
        var author: String { __data["author"] }
        var end: Int { __data["end"] }
      }
    }
  }

}