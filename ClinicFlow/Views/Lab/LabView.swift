import SwiftUI

struct LabView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var navigateToDirections = false
    @State private var navigateToTests = false
    @State private var navigateToRequiredTests = false
    @State private var navigateToInstructions = false
    @State private var navigateToDashboard = false
    
    // Required tests data
    private let requiredTests: [LabTest] = [
        LabTest(name: "Fasting Blood Sugar", icon: "drop.fill", isSelected: true),
        LabTest(name: "Thyroid Function Test", icon: "hourglass", isSelected: true),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        mapCard
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        infoCard(
                            icon: "flask.fill",
                            iconColor: .brand,
                            iconBackground: Color.brand.opacity(0.12),
                            title: "Required Tests",
                            action: { navigateToRequiredTests = true }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                        infoCard(
                            icon: "doc.text.fill",
                            iconColor: Color(red: 0.12, green: 0.65, blue: 0.33),
                            iconBackground: Color(red: 0.12, green: 0.65, blue: 0.33).opacity(0.12),
                            title: "Instructions",
                            action: { navigateToInstructions = true }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        tokenCard
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        Button(action: { navigateToDashboard = true }) {
                            Text("Done")
                                .scalableFont(size: 16, weight: .semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.brand)
                                )
                                .shadow(color: Color.brand.opacity(0.28), radius: 10, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                        Color.clear
                            .frame(height: 90 + geometry.safeAreaInsets.bottom)
                    }
                }
            }
        }
        .clinicNavBar(title: "Lab", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToDirections) {
            DirectionsView()
        }
        .navigationDestination(isPresented: $navigateToTests) {
            AllTestsView(onDone: { navigateToTests = false })
        }
        .navigationDestination(isPresented: $navigateToRequiredTests) {
            RequiredTestsView(requiredTests: requiredTests)
        }
        .navigationDestination(isPresented: $navigateToInstructions) {
            TestInstructionsView()
        }
        .navigationDestination(isPresented: $navigateToDashboard) {
            HomeDashboardView()
        }
    }

    // MARK: - Map Card
    private var mapCard: some View {
        ZStack(alignment: .topLeading) {
            Image("map")
                .resizable()
                .scaledToFill()
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(red: 0.15, green: 0.76, blue: 0.36))
                        .frame(width: 8, height: 8)
                    Text("Precise: On")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(red: 0.19, green: 0.22, blue: 0.29))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.90))
                .clipShape(Capsule())
                .padding(.top, 14)
                .padding(.leading, 14)

                Spacer()
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture { navigateToDirections = true }
    }

    private func infoCard(icon: String, iconColor: Color, iconBackground: Color, title: String, action: (() -> Void)? = nil) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(iconBackground)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(iconColor)
                )

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.20))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(red: 0.62, green: 0.65, blue: 0.72))
        }
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture { action?() }
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.gray.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Token Card
    private var tokenCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Your Token Number")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(red: 0.28, green: 0.32, blue: 0.41))

                Spacer()

                HStack(spacing: 12) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 18, weight: .medium))
                    Image(systemName: "barcode")
                        .font(.system(size: 18, weight: .regular))
                }
                .foregroundStyle(Color(red: 0.62, green: 0.65, blue: 0.72))
            }

            Text("010")
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(Color(red: 0.05, green: 0.11, blue: 0.23))
                .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    LabGhostToken(value: "002")
                    LabGhostToken(value: "003")

                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.brand)
                            .frame(width: 72, height: 72)
                            .overlay(
                                Text("010")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                        Text("Now")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.brand)
                    }

                    LabGhostToken(value: "011")
                    LabGhostToken(value: "012")
                }
                .padding(.horizontal, 4)
            }
            .padding(.top, 14)

            Divider()
                .padding(.top, 18)

            HStack {
                Label("Est. Wait 25 min", systemImage: "clock")
                    .font(.system(size: 13, weight: .regular))
                Spacer()
                Label("08 People Ahead", systemImage: "person.3.fill")
                    .font(.system(size: 13, weight: .regular))
            }
            .foregroundStyle(Color(red: 0.42, green: 0.46, blue: 0.54))
            .padding(.top, 14)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.gray.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

}

// MARK: - Supporting Views

private struct LabGhostToken: View {
    let value: String

    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.13))
            .frame(width: 58, height: 58)
            .overlay(
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(red: 0.40, green: 0.45, blue: 0.54))
            )
    }
}

#Preview {
    LabView()
}
