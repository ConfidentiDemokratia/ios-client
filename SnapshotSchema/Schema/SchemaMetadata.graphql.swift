// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol SnapshotSchema_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == SnapshotSchema.SchemaMetadata {}

protocol SnapshotSchema_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == SnapshotSchema.SchemaMetadata {}

protocol SnapshotSchema_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == SnapshotSchema.SchemaMetadata {}

protocol SnapshotSchema_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == SnapshotSchema.SchemaMetadata {}

extension SnapshotSchema {
  typealias ID = String

  typealias SelectionSet = SnapshotSchema_SelectionSet

  typealias InlineFragment = SnapshotSchema_InlineFragment

  typealias MutableSelectionSet = SnapshotSchema_MutableSelectionSet

  typealias MutableInlineFragment = SnapshotSchema_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Query": return SnapshotSchema.Objects.Query
      case "Proposal": return SnapshotSchema.Objects.Proposal
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}