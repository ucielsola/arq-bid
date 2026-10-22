import ArqBidCore
import SwiftUI

@main
struct ArqBidApp: App {
    @StateObject private var store = BidStore()

    var body: some Scene {
        MenuBarExtra {
            BidPopover(store: store)
        } label: {
            Label(store.menuBarTitle, systemImage: "dollarsign.circle")
                .labelStyle(.titleAndIcon)
                .accessibilityLabel("Cotización USDC en pesos argentinos")
                .accessibilityValue(store.menuBarTitle)
        }
        .menuBarExtraStyle(.window)
    }
}
