// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit
import AlphaWalletFoundation
import BigInt

struct EnterSellTokensCardPriceQuantityViewModel {
    private let server: RPCServer
    private let assetDefinitionStore: AssetDefinitionStore
    private let currencyService: CurrencyService
    lazy var ethToken: Token = MultipleChainsTokensDataStore.functional.etherToken(forServer: server)
    let token: Token
    let tokenHolder: TokenHolder
    var ethCost: Double = .zero
    var dollarCost: String = ""

    var headerTitle: String {
        return R.string.localizable.aWalletTokenSellSelectQuantityTitle()
    }

    var maxValue: Int {
        return tokenHolder.tokens.count
    }

    var quantityLabelText: String {
        let tokenTypeName = XMLHandler(token: token, assetDefinitionStore: assetDefinitionStore).getNameInPluralForm()
        return R.string.localizable.aWalletTokenSellQuantityTitle(tokenTypeName.localizedUppercase)
    }

    var pricePerTokenLabelText: String {
        let tokenTypeName = XMLHandler(token: token, assetDefinitionStore: assetDefinitionStore).getLabel()
        return R.string.localizable.aWalletTokenSellPricePerTokenTitle(tokenTypeName.localizedUppercase)
    }

    var linkExpiryDateLabelText: String {
        return R.string.localizable.aWalletTokenSellLinkExpiryDateTitle()
    }

    var linkExpiryTimeLabelText: String {
        return R.string.localizable.aWalletTokenSellLinkExpiryTimeTitle()
    }

    var ethCostLabelLabelText: String {
        return R.string.localizable.aWalletTokenSellTotalCostTitle()
    }

    var ethCostLabelText: String {
        let amount = NumberFormatter.shortCrypto.string(double: ethCost, minimumFractionDigits: 6, maximumFractionDigits: 8).droppedTrailingZeros
        return "\(amount) \(server.symbol)"
    }

    var dollarCostLabelText: String {
        return "\(currencyService.currency.symbol)\(dollarCost)"
    }

    var hideDollarCost: Bool {
        return dollarCost.trimmed.isEmpty
    }

    init(token: Token, tokenHolder: TokenHolder, server: RPCServer, assetDefinitionStore: AssetDefinitionStore, currencyService: CurrencyService) {
        self.token = token
        self.currencyService = currencyService
        self.tokenHolder = tokenHolder
        self.server = server
        self.assetDefinitionStore = assetDefinitionStore
    }
}
