//
//  WalletConnectSession.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 02.07.2020.
//

import Foundation
import Combine
import AlphaWalletFoundation
import PromiseKit

enum WalletConnectError: Error, LocalizedError {
    case onlyForWatchWallet(address: AlphaWallet.Address)
    case walletsNotFound(addresses: [AlphaWallet.Address])
    case callbackIdMissing
    case connectionFailure(WalletConnectV1URL)
    case `internal`(Error)

    init(error: Error) {
        if let value = error as? WalletConnectError {
            self = value
        } else {
            self = .internal(error)
        }
    }

    var isCancellationError: Bool {
        switch self {
        case .internal(let error):
            if case DAppError.cancelled = error {
                return true
            } else if case PMKError.cancelled = error {
                return true
            }
            return false
        case .walletsNotFound, .onlyForWatchWallet, .callbackIdMissing, .connectionFailure:
            return false
        }
    }

    var localizedDescription: String {
        switch self {
        case .internal(let error):
            return error.localizedDescription
        case .callbackIdMissing, .connectionFailure:
            return R.string.localizable.walletConnectFailureTitle()
        case .onlyForWatchWallet:
            return R.string.localizable.walletConnectFailureMustNotBeWatchedWallet()
        case .walletsNotFound:
            return R.string.localizable.walletConnectFailureWalletsNotFound()
        }
    }
}

protocol WalletConnectResponder: AnyObject {
    func respond(_ response: AlphaWallet.WalletConnect.Response, request: AlphaWallet.WalletConnect.Session.Request) throws
}

protocol WalletConnectServer: WalletConnectResponder {
    var sessions: AnyPublisher<[AlphaWallet.WalletConnect.Session], Never> { get }

    var delegate: WalletConnectServerDelegate? { get set }

    func connect(url: AlphaWallet.WalletConnect.ConnectionUrl) throws
    func session(for topicOrUrl: AlphaWallet.WalletConnect.TopicOrUrl) -> AlphaWallet.WalletConnect.Session?
    func update(_ topicOrUrl: AlphaWallet.WalletConnect.TopicOrUrl, servers: [RPCServer]) throws
    func disconnect(_ topicOrUrl: AlphaWallet.WalletConnect.TopicOrUrl) throws
    func isConnected(_ topicOrUrl: AlphaWallet.WalletConnect.TopicOrUrl) -> Bool
}

protocol WalletConnectServerDelegate: AnyObject {
    func server(_ server: WalletConnectServer, didConnect session: AlphaWallet.WalletConnect.Session)
    func server(_ server: WalletConnectServer, shouldConnectFor proposal: AlphaWallet.WalletConnect.Proposal, completion: @escaping (AlphaWallet.WalletConnect.ProposalResponse) -> Void)
    func server(_ server: WalletConnectServer, action: AlphaWallet.WalletConnect.Action, request: AlphaWallet.WalletConnect.Session.Request, session: AlphaWallet.WalletConnect.Session)
    func server(_ server: WalletConnectServer, didFail error: Error)
    func server(_ server: WalletConnectServer, tookTooLongToConnectToUrl url: AlphaWallet.WalletConnect.ConnectionUrl)
}
