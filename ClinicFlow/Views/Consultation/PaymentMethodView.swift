import SwiftUI

// MARK: - Payment Method View
struct PaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    var skipQRToken: Bool = false
    @State private var selectedMethod = 0
    @State private var cardNumber = ""
    @State private var cardHolder = ""
    @State private var expiry = ""
    @State private var cvc = ""
    @State private var agreeToTerms = false
    @State private var navigateToQRToken = false

    private let methods: [(icon: String, label: String, color: Color)] = [
        ("creditcard.fill",    "Visa",       Color(red: 0.13, green: 0.29, blue: 0.73)),
        ("creditcard",         "Mastercard", Color(red: 0.82, green: 0.18, blue: 0.18)),
        ("banknote",           "PayPal",     Color(red: 0.00, green: 0.40, blue: 0.73)),
        ("building.columns",   "Bank",       Color(red: 0.22, green: 0.60, blue: 0.44)),
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {

                // ── Payment method chips ─────────────────────────
                VStack(alignment: .leading, spacing: 14) {
                    sectionLabel("Payment Method")
                    methodChips
                }

                // ── Card details card ────────────────────────────
                VStack(alignment: .leading, spacing: 14) {
                    sectionLabel("Card Details")
                    cardDetailsCard
                }

                // ── Terms ────────────────────────────────────────
                termsRow

                // ── Action buttons ───────────────────────────────
                actionBar()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Payment", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToQRToken) {
            QRTokenView(onDone: onDone)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Sub-views
    // ─────────────────────────────────────────────────────────────────────────

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .scalableFont(size: 13, weight: .semibold)
            .foregroundColor(Color(.secondaryLabel))
            .textCase(.uppercase)
            .kerning(0.5)
    }

    // ── Payment method chips ─────────────────────────────────────────────────
    private var methodChips: some View {
        HStack(spacing: 12) {
            ForEach(0..<methods.count, id: \.self) { i in
                methodChip(index: i)
            }
        }
    }

    private func methodChip(index: Int) -> some View {
        let m = methods[index]
        let isSelected = selectedMethod == index

        return Button(action: { withAnimation(.spring(response: 0.25)) { selectedMethod = index } }) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? m.color : Color(.systemGray5))
                        .frame(width: 44, height: 44)
                    Image(systemName: m.icon)
                        .scalableFont(size: 18, weight: .medium)
                        .foregroundColor(isSelected ? .white : Color(.secondaryLabel))
                }
                Text(m.label)
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(isSelected ? m.color : Color(.secondaryLabel))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: isSelected ? m.color.opacity(0.18) : .black.opacity(0.05),
                            radius: isSelected ? 10 : 4, x: 0, y: isSelected ? 4 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? m.color.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // ── Card details card ────────────────────────────────────────────────────
    private var cardDetailsCard: some View {
        VStack(spacing: 0) {
            cardField(label: "Card Number", text: $cardNumber,
                      placeholder: "0000  0000  0000  0000",
                      keyboardType: .numberPad, trailing: cardScanBtn)
            divider
            cardField(label: "Card Holder", text: $cardHolder,
                      placeholder: "Full name on card",
                      keyboardType: .default, trailing: EmptyView())
            divider
            HStack(spacing: 0) {
                // Expiry
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expiry Date")
                        .scalableFont(size: 12, weight: .medium)
                        .foregroundColor(Color(.tertiaryLabel))
                    TextField("MM / YY", text: $expiry)
                        .scalableFont(size: 15, weight: .regular)
                        .keyboardType(.numberPad)
                }
                .padding(.leading, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)

                Color(.systemGray5).frame(width: 1, height: 50)

                // CVC
                VStack(alignment: .leading, spacing: 4) {
                    Text("CVC / CVV")
                        .scalableFont(size: 12, weight: .medium)
                        .foregroundColor(Color(.tertiaryLabel))
                    HStack(spacing: 6) {
                        TextField("•••", text: $cvc)
                            .scalableFont(size: 15, weight: .regular)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: .infinity)
                        Image(systemName: "questionmark.circle")
                            .scalableFont(size: 14)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private func cardField<Trailing: View>(
        label: String,
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType,
        trailing: Trailing
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .scalableFont(size: 12, weight: .medium)
                    .foregroundColor(Color(.tertiaryLabel))
                TextField(placeholder, text: text)
                    .scalableFont(size: 15, weight: .regular)
                    .keyboardType(keyboardType)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            trailing
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var cardScanBtn: some View {
        Button(action: {}) {
            Image(systemName: "viewfinder")
                .scalableFont(size: 16, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .frame(height: 1)
            .padding(.horizontal, 16)
    }

    // ── Terms row ────────────────────────────────────────────────────────────
    private var termsRow: some View {
        Button(action: { withAnimation { agreeToTerms.toggle() } }) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(agreeToTerms ? Color.brand : Color(.systemGray3), lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(agreeToTerms ? Color.brand : Color.white)
                        )
                        .frame(width: 22, height: 22)
                    if agreeToTerms {
                        Image(systemName: "checkmark")
                            .scalableFont(size: 11, weight: .bold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 1)

                Text("I agree to the **Terms of Service** and **Privacy Policy**")
                    .scalableFont(size: 13)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }

    // ── Action bar ───────────────────────────────────────────────────────────
    private func actionBar() -> some View {
        HStack(spacing: 12) {
                // Decline
                Button(action: { dismiss() }) {
                    Text("Decline")
                        .scalableFont(size: 16, weight: .semibold)
                        .foregroundColor(.brand)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.brand, lineWidth: 1.5)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.white)
                                )
                        )
                }
                .buttonStyle(.plain)

                // Confirm
                Button(action: {
                    if agreeToTerms {
                        if skipQRToken {
                            onDone?()
                        } else {
                            navigateToQRToken = true
                        }
                    }
                }) {
                    Text("Confirm")
                        .scalableFont(size: 16, weight: .semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(agreeToTerms ? Color.brand : Color(.systemGray3))
                        )
                        .shadow(color: agreeToTerms ? Color.brand.opacity(0.30) : .clear,
                                radius: 10, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .disabled(!agreeToTerms)
                .animation(.easeOut(duration: 0.2), value: agreeToTerms)
        }
    }

    // ── Tab bar ──────────────────────────────────────────────────────────────
    // (Kept for project-wide structural parity — same 4-tab bar)
    private var tabBar: some View {
        let tabs: [(icon: String, label: String)] = [
            ("house.fill", "Home"), ("calendar", "Booking"),
            ("doc.text",   "Records"), ("person",   "Profile"),
        ]
        return HStack(spacing: 0) {
            ForEach(0..<4, id: \.self) { i in
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[i].icon)
                            .scalableFont(size: 20, weight: .semibold)
                        Text(tabs[i].label)
                            .scalableFont(size: 10, weight: .medium)
                    }
                    .foregroundColor(i == 0 ? .brand : Color(red: 0.62, green: 0.65, blue: 0.72))
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

// MARK: - Preview
#Preview {
    PaymentMethodView()
}
