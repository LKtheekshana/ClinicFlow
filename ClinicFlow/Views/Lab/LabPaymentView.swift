import SwiftUI

// MARK: - Lab Payment View
struct LabPaymentView: View {
    @Environment(\.dismiss) private var dismiss

    var selectedTests: [LabTest]
    var onDone: (() -> Void)? = nil

    @State private var selectedMethod    = 0
    @State private var agreeToTerms      = false
    @State private var isPaid            = false
    @State private var navigateToLabView = false

    // ── Lab-specific payment methods ─────────────────────────────────────────
    private let methods: [(icon: String, label: String, color: Color)] = [
        ("creditcard.fill",  "Card",      Color(red: 0.13, green: 0.29, blue: 0.73)),
        ("banknote",         "Cash",      Color(red: 0.22, green: 0.60, blue: 0.44)),
        ("cross.case.fill",  "Insurance", Color(red: 0.78, green: 0.18, blue: 0.18)),
        ("building.2.fill",  "Hospital",  Color.brand),
    ]

    // ── Mock prices per test (LKR) ────────────────────────────────────────────
    private static let prices: [String: Int] = [
        "Comprehensive Full Body Checkup": 8500,
        "Fasting Blood Sugar":              350,
        "Lipid Profile":                   1200,
        "Thyroid Function Test":           1800,
        "Complete Blood Count":             650,
        "Vitamin D Test":                  2200,
    ]

    private var subtotal:   Int { selectedTests.reduce(0) { $0 + (Self.prices[$1.name] ?? 500) } }
    private var serviceFee: Int { 150 }
    private var total:      Int { subtotal + serviceFee }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Body
    // ─────────────────────────────────────────────────────────────────────────
    var body: some View {
        Group {
            if isPaid {
                successView
            } else {
                paymentContent
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(
            title: isPaid ? "Payment Done" : "Lab Payment",
            onBack: { dismiss() }
        )
        .navigationDestination(isPresented: $navigateToLabView) {
            LabView(onDone: onDone)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Payment content
    // ─────────────────────────────────────────────────────────────────────────
    private var paymentContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                testsSummaryCard

                priceCard

                VStack(alignment: .leading, spacing: 12) {
                    sectionLabel("Payment Method")
                    methodChips
                }

                termsRow

                actionButtons
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }

    // ── Selected tests summary ────────────────────────────────────────────────
    private var testsSummaryCard: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.brand.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: "flask.fill")
                        .scalableFont(size: 15, weight: .medium)
                        .foregroundColor(.brand)
                }
                Text("Selected Tests")
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(selectedTests.count) test\(selectedTests.count == 1 ? "" : "s")")
                    .scalableFont(size: 12, weight: .semibold)
                    .foregroundColor(Color.brand)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.brand.opacity(0.10)))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()

            if selectedTests.isEmpty {
                Text("No tests selected")
                    .scalableFont(size: 14)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(16)
            } else {
                ForEach(selectedTests) { test in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.brand.opacity(0.10))
                                .frame(width: 38, height: 38)
                            Image(systemName: test.icon)
                                .scalableFont(size: 14, weight: .medium)
                                .foregroundColor(.brand)
                        }
                        Text(test.name)
                            .scalableFont(size: 14, weight: .medium)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("LKR \(Self.prices[test.name] ?? 500)")
                            .scalableFont(size: 14, weight: .semibold)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if test.id != selectedTests.last?.id {
                        Divider().padding(.leading, 66)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    // ── Price breakdown ───────────────────────────────────────────────────────
    private var priceCard: some View {
        VStack(spacing: 0) {
            priceRow(label: "Subtotal", value: subtotal)
            Divider().padding(.horizontal, 16)
            priceRow(label: "Service Fee", value: serviceFee)
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
            HStack {
                Text("Total")
                    .scalableFont(size: 16, weight: .bold)
                    .foregroundColor(.primary)
                Spacer()
                Text("LKR \(total)")
                    .scalableFont(size: 18, weight: .bold)
                    .foregroundColor(.brand)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    private func priceRow(label: String, value: Int) -> some View {
        HStack {
            Text(label)
                .scalableFont(size: 14, weight: .regular)
                .foregroundColor(Color(.secondaryLabel))
            Spacer()
            Text("LKR \(value)")
                .scalableFont(size: 14, weight: .semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // ── Section label ─────────────────────────────────────────────────────────
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .scalableFont(size: 13, weight: .semibold)
            .foregroundColor(Color(.secondaryLabel))
            .textCase(.uppercase)
            .kerning(0.5)
    }

    // ── Payment method chips ──────────────────────────────────────────────────
    private var methodChips: some View {
        HStack(spacing: 10) {
            ForEach(0..<methods.count, id: \.self) { i in
                let m = methods[i]
                let isSelected = selectedMethod == i
                Button(action: {
                    withAnimation(.spring(response: 0.25)) { selectedMethod = i }
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(isSelected ? m.color : Color(.systemGray5))
                                .frame(width: 44, height: 44)
                            Image(systemName: m.icon)
                                .scalableFont(size: 17, weight: .medium)
                                .foregroundColor(isSelected ? .white : Color(.secondaryLabel))
                        }
                        Text(m.label)
                            .scalableFont(size: 11, weight: .medium)
                            .foregroundColor(isSelected ? m.color : Color(.secondaryLabel))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                            .shadow(
                                color: isSelected ? m.color.opacity(0.18) : .black.opacity(0.05),
                                radius: isSelected ? 10 : 4,
                                x: 0,
                                y: isSelected ? 4 : 2
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isSelected ? m.color.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // ── Terms row ─────────────────────────────────────────────────────────────
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

    // ── Action buttons ────────────────────────────────────────────────────────
    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Cancel
            Button(action: { dismiss() }) {
                Text("Cancel")
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

            // Pay Now
            Button(action: {
                if agreeToTerms {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        isPaid = true
                    }
                }
            }) {
                Text("Pay Now")
                    .scalableFont(size: 16, weight: .semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(agreeToTerms ? Color.brand : Color(.systemGray3))
                    )
                    .shadow(
                        color: agreeToTerms ? Color.brand.opacity(0.30) : .clear,
                        radius: 10, x: 0, y: 4
                    )
            }
            .buttonStyle(.plain)
            .disabled(!agreeToTerms)
            .animation(.easeOut(duration: 0.2), value: agreeToTerms)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Success View
    // ─────────────────────────────────────────────────────────────────────────
    private var successView: some View {
        VStack(spacing: 0) {
            Spacer()

            // Success icon + message
            VStack(spacing: 20) {
                Circle()
                    .fill(Color(red: 0.16, green: 0.72, blue: 0.40))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: "checkmark")
                            .scalableFont(size: 36, weight: .bold)
                            .foregroundColor(.white)
                    )
                    .shadow(
                        color: Color(red: 0.16, green: 0.72, blue: 0.40).opacity(0.30),
                        radius: 16, x: 0, y: 8
                    )

                VStack(spacing: 8) {
                    Text("Payment Successful!")
                        .scalableFont(size: 22, weight: .bold)
                        .foregroundColor(Color(red: 0.08, green: 0.12, blue: 0.20))
                    Text("Your lab tests are confirmed.\nProceed to the lab for sample collection.")
                        .scalableFont(size: 14, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)

            // Receipt card
            VStack(spacing: 0) {
                HStack {
                    Text("Amount Paid")
                        .scalableFont(size: 14, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                    Text("LKR \(total)")
                        .scalableFont(size: 16, weight: .bold)
                        .foregroundColor(.brand)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

                Divider().padding(.horizontal, 12)

                HStack {
                    Text("Tests Booked")
                        .scalableFont(size: 14, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                    Text("\(selectedTests.count) test\(selectedTests.count == 1 ? "" : "s")")
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

                Divider().padding(.horizontal, 12)

                HStack {
                    Text("Payment Method")
                        .scalableFont(size: 14, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                    Text(methods[selectedMethod].label)
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
            )
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer()

            // Go to Lab View button
            Button(action: { navigateToLabView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "flask.fill")
                    Text("Go to Lab View")
                }
                .scalableFont(size: 16, weight: .semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.brand)
                        .shadow(color: Color.brand.opacity(0.28), radius: 12, x: 0, y: 5)
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LabPaymentView(
            selectedTests: [
                LabTest(name: "Fasting Blood Sugar",   icon: "drop.fill",    isSelected: true),
                LabTest(name: "Thyroid Function Test", icon: "hourglass",    isSelected: true),
                LabTest(name: "Vitamin D Test",        icon: "plus.circle.fill", isSelected: true),
            ]
        )
    }
}
