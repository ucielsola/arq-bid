import ArqBidCore
import SwiftUI

struct BidPopover: View {
    @ObservedObject var store: BidStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("USDC / ARS")
                        .font(.headline)
                    Text("Valor bid")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .accessibilityHidden(true)
            }

            if let usdcARS = store.usdcARS {
                Text(CurrencyFormatter.string(from: usdcARS))
                    .font(.largeTitle.weight(.semibold))
                    .accessibilityLabel("Bid de USDC en pesos argentinos")
            } else if store.isLoading {
                ProgressView("Cargando")
            } else {
                Text("Sin datos")
                    .foregroundStyle(.secondary)
            }

            if let eurcARS = store.eurcARS {
                RateRow(title: "EURC / ARS", value: CurrencyFormatter.string(from: eurcARS))
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Variación · \(store.history.snapshots.count) registros")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.72))

                if let usdcChange = store.usdcChange {
                    ChangeRow(title: "USDC / ARS", change: usdcChange)
                }

                if let eurcChange = store.eurcChange {
                    ChangeRow(title: "EURC / ARS", change: eurcChange)
                }

                if store.usdcChange == nil && store.eurcChange == nil {
                    Text("Disponible después de la próxima actualización")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.72))
                }
            }
            .padding(12)
            .background(.black, in: .rect(cornerRadius: 12))

            if let updatedAt = store.updatedAt {
                Text("Actualizado \(updatedAt, style: .relative)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage = store.errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()

            Button("Actualizar ahora", systemImage: "arrow.clockwise", action: refresh)
                .buttonStyle(.borderless)
                .disabled(store.isLoading)

            Button("Salir", action: quit)
                .keyboardShortcut("q")
        }
        .frame(width: 280)
        .padding(18)
        .modifier(ClearWindowBackground())
    }

    private func refresh() {
        Task {
            await store.refresh()
        }
    }

    private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
