////
////  AsyncButton.swift
////  Confidate App
////
////  Created by Nikolai Trukhin on 16.03.2024.
////
//
//import SwiftUI
//
//struct AsyncButton<S: View>: View {
//    private let action: () async -> Void
//    private let label: S
//
//    @State private var task: Task<Void, Never>?
//
//    var body: some View {
//        Button {
//            guard task == nil else {
//                return
//            }
//            task = Task {
//                await action()
//                task = nil
//            }
//        } label: {
//            if task != nil {
//                ProgressView()
//            } else {
//                label
//            }
//        }
//    }
//
//    init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> S) {
//        self.action = action
//        self.label = label()
//    }
//}
//
//public protocol AsyncButtonStyle {
//    associatedtype Label: View
//    associatedtype Button: View
//    typealias LabelConfiguration = AsyncButtonStyleLabelConfiguration
//    typealias ButtonConfiguration = AsyncButtonStyleButtonConfiguration
//
//    @ViewBuilder func makeLabel(configuration: LabelConfiguration) -> Label
//    @ViewBuilder func makeButton(configuration: ButtonConfiguration) -> Button
//}
//
//public struct AsyncButtonStyleLabelConfiguration {
//    typealias Label = AnyView
//
//    let isLoading: Bool
//    let label: Label
//    let cancel: () -> Void
//}
//
//public struct AsyncButtonStyleButtonConfiguration {
//    typealias Button = AnyView
//
//    let isLoading: Bool
//    let button: Button
//    let cancel: () -> Void
//}
//
//struct EllipsisAsyncButtonStyle: AsyncButtonStyle {
//    @State private var animated = false
//
//    func makeLabel(configuration: LabelConfiguration) -> some View {
//        configuration.label
//            .opacity(configuration.isLoading ? 0 : 1)
//            .overlay {
//                Image(systemName: "ellipsis")
//                    .symbolEffect(.variableColor.iterative.dimInactiveLayers, options: .repeating, value: configuration.isLoading)
//                    .font(.title)
//                    .opacity(configuration.isLoading ? 1 : 0)
//            }
//            .animation(.default, value: configuration.isLoading)
//    }
//
//    // Facultative, as ButtonKit comes with a default implementation for both.
//    func makeButton(configuration: ButtonConfiguration) -> some View {
//        configuration.button
//    }
//}
//
//extension AsyncButtonStyle where Self == EllipsisAsyncButtonStyle {
//    static var ellipsis: EllipsisAsyncButtonStyle {
//        EllipsisAsyncButtonStyle()
//    }
//}
