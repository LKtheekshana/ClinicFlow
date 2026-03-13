import SwiftUI

// MARK: - Prescription View
struct PrescriptionView: View {
    @Environment(\.dismiss) private var dismiss

    // ── Sample data (replace with real model as needed) ──────────────────────
    private let pharmacyName  = "City Pharmacy Colombo"
    private let pharmacyPhone = "+923048457"

    private let prescriptionID = "17514397/1278"
    private let date           = "Jul 02, 2025"
    private let expiry         = "Jul 07, 2025"
    private let status         = "Valid"

    private let clientName    = "Isuru"
    private let clientPhone   = "+94302154785"
    private let clientAddress = "City Housing"

    private let medicationItem  = "Amoxicillin 500mg"
    private let medicationPrice = "$25.00"

    private let dosageItems: [(medicine: String, dosage: String)] = [
        ("Amoxicillin",  "500"),
        ("Paracetamol",  "650"),
        ("Ibuprofen",    "400"),
        ("Omeprazole",   "20"),
        ("Vitamin C",    "1000"),
        ("Antacid",      "500"),
    ]

    private let prescriptionNotes     = "Pending Order"
    private let specialInstructions   = "Take with food"
    private let dosageNotes           = "Special Medication"

    // ─────────────────────────────────────────────────────────────────────────
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    // ── Scrollable content ────────────────────────────────
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Pharmacy banner
                            pharmacyBanner
                                .padding(.horizontal, 20)

                            // Sections
                            VStack(spacing: 14) {
                                detailsCard
                                medicationCard
                                dosageCard
                                notesCard
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 14)
                            .padding(.bottom, 100 + geo.safeAreaInsets.bottom)
                        }
                    }


                }
            }
        }
        .clinicNavBar(title: "Prescription", onBack: { dismiss() }) {
            ToolbarCircleButton(icon: "arrow.down.to.line", action: {})
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Pharmacy banner
    // ─────────────────────────────────────────────────────────────────────────
    private var pharmacyBanner: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.76, green: 0.18, blue: 0.14),
                                 Color(red: 0.60, green: 0.10, blue: 0.08)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: 6)
                .clipShape(
                    .rect(topLeadingRadius: 18, bottomLeadingRadius: 0,
                          bottomTrailingRadius: 0, topTrailingRadius: 18)
                )

            VStack(spacing: 4) {
                Text(pharmacyName)
                    .scalableFont(size: 16, weight: .bold)
                    .foregroundColor(.primary)
                Text("Phone: \(pharmacyPhone)")
                    .scalableFont(size: 13)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.white)
            .clipShape(
                .rect(topLeadingRadius: 0, bottomLeadingRadius: 18,
                      bottomTrailingRadius: 18, topTrailingRadius: 0)
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Prescription + Client details card
    // ─────────────────────────────────────────────────────────────────────────
    private var detailsCard: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left — Prescription details
            VStack(alignment: .leading, spacing: 8) {
                Text("Prescription Details")
                    .scalableFont(size: 14, weight: .bold)
                    .foregroundColor(.primary)
                detailRow(label: "Prescription ID:", value: prescriptionID)
                detailRow(label: "Date:", value: date)
                detailRow(label: "Expiry:", value: expiry)
                // Status badge
                HStack(spacing: 4) {
                    Text("Status:")
                        .scalableFont(size: 12)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(status)
                        .scalableFont(size: 12, weight: .semibold)
                        .foregroundColor(Color(red: 0.10, green: 0.60, blue: 0.22))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Vertical divider
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 1)
                .padding(.vertical, 4)
                .frame(height: nil)

            // Right — Client details
            VStack(alignment: .leading, spacing: 8) {
                Text("Client Details")
                    .scalableFont(size: 14, weight: .bold)
                    .foregroundColor(.primary)
                detailRow(label: "Name:", value: clientName)
                detailRow(label: "Phone:", value: clientPhone)
                detailRow(label: "Address:", value: clientAddress)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 14)
        }
        .padding(18)
        .cardStyle()
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label)
                .scalableFont(size: 11)
                .foregroundColor(Color(.tertiaryLabel))
            Text(value)
                .scalableFont(size: 12, weight: .medium)
                .foregroundColor(.primary)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Medication information card
    // ─────────────────────────────────────────────────────────────────────────
    private var medicationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Medication Information")
                .scalableFont(size: 14, weight: .bold)
                .foregroundColor(.primary)
            Divider()
            infoRow(label: "Item:", value: medicationItem)
            infoRow(label: "Price:", value: medicationPrice)
        }
        .padding(18)
        .cardStyle()
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .scalableFont(size: 13)
                .foregroundColor(Color(.secondaryLabel))
            Text(value)
                .scalableFont(size: 13, weight: .medium)
                .foregroundColor(.primary)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Dosage instructions card
    // ─────────────────────────────────────────────────────────────────────────
    private var dosageCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dosage Instructions")
                .scalableFont(size: 14, weight: .bold)
                .foregroundColor(.primary)

            // Table container
            VStack(spacing: 0) {
                // Header row
                HStack {
                    Text("Medicine")
                        .scalableFont(size: 12, weight: .semibold)
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Dosage (mg)")
                        .scalableFont(size: 12, weight: .semibold)
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))

                Divider()

                ForEach(Array(dosageItems.enumerated()), id: \.offset) { idx, item in
                    HStack {
                        Text(item.medicine)
                            .scalableFont(size: 13)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(item.dosage)
                            .scalableFont(size: 13, weight: .medium)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(idx.isMultiple(of: 2) ? Color.white : Color(.systemGray6).opacity(0.4))

                    if idx < dosageItems.count - 1 {
                        Divider().padding(.horizontal, 14)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 0.8)
            )
        }
        .padding(18)
        .cardStyle()
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Notes & instructions card
    // ─────────────────────────────────────────────────────────────────────────
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes & Instructions")
                .scalableFont(size: 14, weight: .bold)
                .foregroundColor(.primary)
            Divider()
            noteRow(label: "Prescription Notes:", value: prescriptionNotes)
            noteRow(label: "Special Instructions:", value: specialInstructions)
            noteRow(label: "Dosage Notes:", value: dosageNotes)
        }
        .padding(18)
        .cardStyle()
    }

    private func noteRow(label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .scalableFont(size: 13)
                .foregroundColor(Color(.secondaryLabel))
            Text(value)
                .scalableFont(size: 13, weight: .medium)
                .foregroundColor(.primary)
        }
    }

}

// ── Card style modifier ───────────────────────────────────────────────────────
private extension View {
    func cardStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}


// MARK: - Preview
#Preview {
    PrescriptionView()
}
