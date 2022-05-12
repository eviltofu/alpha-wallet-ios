//
//  InitialNetworkSelectionCollectionModel.swift
//  AlphaWallet
//
//  Created by Jerome Chan on 10/5/22.
//

import UIKit

struct InitialNetworkSelectionCollectionModel {

    // MARK: - enums

    enum Mode: Int, CaseIterable {
        case mainnet = 0
        case testnet = 1
    }

    // MARK: - variables (private)

    private let mainnetServers: [RPCServer]
    private let testnetServers: [RPCServer]
    private var filteredMainnetServers: [RPCServer]
    private var filteredTestnetServers: [RPCServer]

    // MARK: - variables

    private(set) var selected: Set<RPCServer>
    var mode: InitialNetworkSelectionCollectionModel.Mode = .mainnet

    // MARK: - accessors

    var count: Int {
        switch mode {
        case .mainnet:
            return filteredMainnetServers.count
        case .testnet:
            return filteredTestnetServers.count
        }
    }

    var filtered: [RPCServer] {
        switch mode {
        case .mainnet:
            return filteredMainnetServers
        case .testnet:
            return filteredTestnetServers
        }
    }

    // MARK: - Initializers

    init(servers: [RPCServer] = RPCServer.allCases, selected: Set<RPCServer> = []) {
        mainnetServers = servers.filter { !$0.isTestnet }
        testnetServers = servers.filter { $0.isTestnet }
        filteredMainnetServers = mainnetServers
        filteredTestnetServers = testnetServers
        self.selected = selected
    }

    // MARK: - functions (public)

    mutating func filter(keyword rawKeyword: String) {
        let keyword = rawKeyword.lowercased().trimmed
        if keyword.isEmpty {
            filteredMainnetServers = mainnetServers
            filteredTestnetServers = testnetServers
            return
        }
        filteredMainnetServers = mainnetServers.filter { $0.match(keyword: keyword) }
        filteredTestnetServers = testnetServers.filter { $0.match(keyword: keyword) }
    }

    mutating func addSelected(server: RPCServer) {
        selected.insert(server)
    }

    mutating func removeSelected(server: RPCServer) {
        selected.remove(server)
    }

    func isSelected(server: RPCServer) -> Bool {
        selected.contains(server)
    }

    func server(for indexPath: IndexPath) -> RPCServer {
        let row = indexPath.row
        return filtered[row]
    }

    func countFor(mode: InitialNetworkSelectionCollectionModel.Mode) -> Int {
        switch mode {
        case .mainnet:
            return filteredMainnetServers.count
        case .testnet:
            return filteredTestnetServers.count
        }
    }

}

fileprivate extension RPCServer {
    func match(keyword: String) -> Bool {
        self.name.lowercased().contains(keyword) || String(self.chainID).contains(keyword)
    }
}