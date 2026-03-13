import SwiftUI

// MARK: - Model
struct PaymentTransaction: Identifiable {
    let id = UUID()
    let service:       String
    let icon:          String
    let transactionID: String
    let amount:        Double
    let date:          String
    let status:        Status

    enum Status {
        case confirmed, pending, failed

        var label: String {
            switch self {
            case .confirmed: return "confirmed"
            case .pending:   return "pending"
            case .failed:    return "failed"
            }
        }
        var foreground: Color {
            switch self {
            case .confirmed: return Color(red: 0.10, green: 0.60, blue: 0.28)
            case .pending:   return Color(red: 0.82, green: 0.55, blue: 0.08)
            case .failed:    return Color(red: 0.82, green: 0.16, blue: 0.14)
            }
        }
        var background: Color { foreground.opacity(0.12) }
    }
}

// MARK: - View
struct PaymentHistoryView: View {
    @Environment(\.dismiss) private var dismiss

    private let transactions: [PaymentTransaction] = [
        PaymentTransaction(service: "Lab Test",
                           icon: "flask.fill",
                           transactionID: "8094554317",
                           amount: 550.00,
                           date: "17 Feb 2026  11:31 AM",
                           status: .pending),
        PaymentTransaction(service: "Pharmacy",
                           icon: "pills.fill",
                           transactionID: "8094554317",
                           amount: 850.00,
                           date: "17 Feb 2026  11:31 AM",
                           status: .confirmed),
        PaymentTransaction(service: "Consultation",
                           icon: "stethoscope",
                           transactionID: "8094554315",
                           amount: 1200.00,
                           date: "16 Feb 2026  09:45 AM",
                           status: .confirmed),
        PaymentTransaction(service: "X-Ray",
                           icon: "rays",
                           transactionID: "8094554312",
                           amount: 750.00,
                           date: "15 Feb 2026  02:20 PM",
                           status: .confirmed),
    ]

    private var totalSpent: Double { transactions.map(\.amount).reduce(0, +) }
    private var confirmedCount: Int { transactions.filter { $0.status == .confirmed }.count }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {


                            // ── Summary card ──────────────────────────────
                            summaryCard
                                .padding(.horizontal, 20)
                                .padding(.bottom, 24)

                            // ── Section label ─────────────────────────────
                            Text("Transactions")
                                .scalableFont(size: 13, weight: .semibold)
                                .foregroundColor(Color(.secondaryLabel))
                                .textCase(.uppercase)
                                .kerning(0.4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 12)

                            // ── Transaction list ──────────────────────────
                            VStack(spacing: 12) {
                                ForEach(transactions) { tx in
                                    transactionCard(tx)
                                        .padding(.horizontal, 20)
                                }
                            }

                            Spacer(minLength: 90 + geo.safeAreaInsets.bottom)
                        }
                    }
                }
            }
        }
        .clinicNavBar(title: "Payment History", onBack: { dismiss() }) {
            ToolbarCircleButton(icon: "arrow.down.to.line", action: {})
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Summary card
    // ─────────────────────────────────────────────────────────────────────────
    private var summaryCard: some View {
        HStack(spacing: 0) {
            // Total spent
            VStack(spacing: 4) {
                Text("Total Spent")
                    .scalableFont(size: 12, weight: .medium)
                    .foregroundColor(.white.opacity(0.80))
                Text(String(format: "%.2f", totalSpent))
                    .scalableFont(size: 26, weight: .bold)
                    .foregroundColor(.white)
                Text("LKR")
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(.white.opacity(0.70))
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.white.opacity(0.22))
                .frame(width: 1, height: 54)

            // Confirmed
            VStack(spacing: 4) {
                Text("Confirmed")
                    .scalableFont(size: 12, weight: .medium)
                    .foregroundColor(.white.opacity(0.80))
                Text("\(confirmedCount)")
                    .scalableFont(size: 26, weight: .bold)
                    .foregroundColor(.white)
                Text("payments")
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(.white.opacity(0.70))
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.white.opacity(0.22))
                .frame(width: 1, height: 54)

            // Total count
            VStack(spacing: 4) {
                Text("Total")
                    .scalableFont(size: 12, weight: .medium)
                    .foregroundColor(.white.opacity(0.80))
                Text("\(transactions.count)")
                    .scalableFont(size: 26, weight: .bold)
                    .foregroundColor(.white)
                Text("records")
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(.white.opacity(0.70))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.26, green: 0.52, blue: 0.96),
                                 Color(red: 0.14, green: 0.36, blue: 0.88)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.brand.opacity(0.32), radius: 16, x: 0, y: 7)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Transaction card
    // ─────────────────────────────────────────────────────────────────────────
    private func transactionCard(_ tx: PaymentTransaction) -> some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.26, green: 0.52, blue: 0.96),
                                     Color(red: 0.14, green: 0.36, blue: 0.88)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: Color.brand.opacity(0.22), radius: 6, x: 0, y: 3)
                Image(systemName: tx.icon)
                    .scalableFont(size: 20, weight: .medium)
                    .foregroundColor(.white)
            }

            // Labels
            VStack(alignment: .leading, spacing: 5) {
                Text(tx.service)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(.primary)

                HStack(spacing: 4) {
                    Text("Transaction ID")
                        .scalableFont(size: 11)
                        .foregroundColor(Color(.tertiaryLabel))
                }

                Text(tx.transactionID)
                    .scalableFont(size: 13, weight: .bold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Amount + status + date
            VStack(alignment: .trailing, spacing: 5) {
                Text(String(format: "%.2f", tx.amount))
                    .scalableFont(size: 16, weight: .bold)
                    .foregroundColor(.primary)

                Text(tx.status.label)
                    .scalableFont(size: 11, weight: .semibold)
                    .foregroundColor(tx.status.foreground)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(tx.status.background)
                    )

                Text(tx.date)
                    .scalableFont(size: 10)
                    .foregroundColor(Color(.tertiaryLabel))
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

}

// MARK: - Preview
#Preview {
    PaymentHistoryView()
}
