import SwiftUI

struct PharmacyView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var navigateToPrescription = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        prescriptionCard
                            .padding(.horizontal, 24)
                            .padding(.top, 22)

                        Text("Pharmacy Status")
                            .scalableFont(size: 17, weight: .semibold)
                            .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.20))
                            .padding(.horizontal, 24)
                            .padding(.top, 34)

                        statusCard
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        Button {
                            onDone?()
                        } label: {
                            Text("Done")
                                .scalableFont(size: 16, weight: .medium)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.brand)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color.brand.opacity(0.20), radius: 7, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 24)

                        Spacer(minLength: 95)
                    }
                }
            }
        }
        .clinicNavBar(title: "Pharmacy", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToPrescription) {
            PrescriptionView()
        }
    }



    private var prescriptionCard: some View {
        Button(action: { navigateToPrescription = true }) {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.brand.opacity(0.9))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "pills.fill")
                        .scalableFont(size: 22, weight: .medium)
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Prescription")
                    .scalableFont(size: 16, weight: .semibold)
                    .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.22))

                Text("Current medication")
                    .scalableFont(size: 13, weight: .regular)
                    .foregroundStyle(Color(red: 0.33, green: 0.38, blue: 0.46))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .scalableFont(size: 14, weight: .semibold)
                .foregroundStyle(Color(red: 0.62, green: 0.65, blue: 0.72))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(red: 0.89, green: 0.92, blue: 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
        )
        } // Button
        .buttonStyle(.plain)
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            statusItem(
                color: .brand,
                title: "Preparing",
                subtitle: "Medicine – Est. Wait 15 min"
            )

            statusItem(
                color: Color(red: 0.16, green: 0.76, blue: 0.36),
                title: "Done",
                subtitle: "Medicine •"
            )
            .padding(.top, 24)

            HStack(alignment: .top, spacing: 14) {
                Rectangle()
                    .fill(Color(red: 0.28, green: 0.82, blue: 0.46))
                    .frame(width: 6)

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .scalableFont(size: 24, weight: .semibold)
                        .foregroundStyle(Color(red: 0.16, green: 0.76, blue: 0.36))

                    Text("Your prescription has been\nreceived. The pharmacy will\nnotify you once your medicine is\nready for pickup.")
                        .scalableFont(size: 13, weight: .regular)
                        .foregroundStyle(Color(red: 0.10, green: 0.42, blue: 0.20))
                        .lineSpacing(6)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(red: 0.88, green: 0.95, blue: 0.91))
                )
            }
            .padding(.top, 24)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.gray.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }

    private func statusItem(color: Color, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(color)
                .frame(width: 22, height: 22)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .scalableFont(size: 16, weight: .semibold)
                    .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.20))

                Text(subtitle)
                    .scalableFont(size: 13, weight: .regular)
                    .foregroundStyle(Color(red: 0.33, green: 0.38, blue: 0.46))
            }
        }
    }

}

#Preview {
    PharmacyView()
}
