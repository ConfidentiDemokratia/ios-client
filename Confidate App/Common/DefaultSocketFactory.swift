//
//  DefaultSocketFactory.swift
//  Confidate App
//
//  Created by Nikolai Trukhin on 15.03.2024.
//

import Foundation
import Starscream
import WalletConnectRelay

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        let socket = WebSocket(url: url)
        let queue = DispatchQueue(label: "com.walletconnect.sdk.sockets", attributes: .concurrent)
        socket.callbackQueue = queue
        return socket
    }
}
