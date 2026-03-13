import SwiftUI

// MARK: - Settings Row Model
private struct SettingsRow: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    var type: RowType = .navigate

    enum RowType {
        case navigate
        case toggle(Binding<Bool>)
        case destructive
    }
}

// MARK: - View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var voiceGuidance: VoiceGuidanceManager

    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @State private var faceIDEnabled = true
    @State private var navigateToUserProfile    = false
    @State private var navigateToPaymentHistory = false
    @State private var navigateToAccessibility  = false
    @State private var showLogoutAlert = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {

                            // Profile banner
                            profileBanner
                                .padding(.horizontal, 20)
                                .padding(.bottom, 24)

                            // Account section
                            settingsGroup(rows: accountRows, actions: [
                                0: { navigateToUserProfile    = true },
                                1: { navigateToPaymentHistory = true },
                                3: { navigateToAccessibility  = true },
                                4: { showLogoutAlert = true },
                            ])
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)

                            // Support section
                            settingsGroup(rows: supportRows)
                                .padding(.horizontal, 20)

                            Spacer(minLength: 100 + geo.safeAreaInsets.bottom)
                        }
                    }

                }
            }
        }
        .clinicNavBar(title: "Profile")
        .onAppear {
            voiceGuidance.announceScreen(title: "Settings and Profile", instructions: "Manage your account, payment methods, accessibility settings, and app preferences.")
        }
        .navigationDestination(isPresented: $navigateToUserProfile) {
            AllProfilesView()
        }
        .navigationDestination(isPresented: $navigateToAccessibility) {
            AccessibilitySettingsView()
        }
        .navigationDestination(isPresented: $navigateToPaymentHistory) {
            PaymentHistoryView()
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Log Out", role: .destructive) {
                isOnboardingComplete = false
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Profile banner
    // ─────────────────────────────────────────────────────────────────────────
    private var profileBanner: some View {
        HStack(spacing: 18) {
            // Avatar initials circle
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 66, height: 66)
                Text("DC")
                    .scalableFont(size: 22, weight: .bold)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Dineth Chandima")
                    .scalableFont(size: 20, weight: .bold)
                    .foregroundColor(.white)
                Text("@thisisuname")
                    .scalableFont(size: 13)
                    .foregroundColor(.white.opacity(0.80))
            }

            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.26, green: 0.52, blue: 0.96),
                                 Color(red: 0.18, green: 0.38, blue: 0.88)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.brand.opacity(0.30), radius: 14, x: 0, y: 6)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Row data
    // ─────────────────────────────────────────────────────────────────────────
    private var accountRows: [SettingsRowItem] {[
        SettingsRowItem(
            icon: "person.fill",
            iconColor: Color(red: 0.26, green: 0.52, blue: 0.96),
            iconBackground: Color(red: 0.26, green: 0.52, blue: 0.96).opacity(0.12),
            title: "Profile",
            subtitle: "Make changes to your profile",
            rowType: .navigate
        ),
        SettingsRowItem(
            icon: "creditcard.fill",
            iconColor: Color(red: 0.14, green: 0.66, blue: 0.38),
            iconBackground: Color(red: 0.14, green: 0.66, blue: 0.38).opacity(0.12),
            title: "Payments",
            subtitle: "Manage your saved accounts",
            rowType: .navigate
        ),
        SettingsRowItem(
            icon: "touchid",
            iconColor: Color(red: 0.58, green: 0.28, blue: 0.86),
            iconBackground: Color(red: 0.58, green: 0.28, blue: 0.86).opacity(0.12),
            title: "Face ID / Touch ID",
            subtitle: "Manage your device security",
            rowType: .toggle
        ),
        SettingsRowItem(
            icon: "figure.walk.circle.fill",
            iconColor: Color(red: 0.90, green: 0.55, blue: 0.10),
            iconBackground: Color(red: 0.90, green: 0.55, blue: 0.10).opacity(0.12),
            title: "Accessibility",
            subtitle: "Theme, text size and display options",
            rowType: .navigate
        ),
        SettingsRowItem(
            icon: "arrow.right.square.fill",
            iconColor: Color(red: 0.90, green: 0.26, blue: 0.22),
            iconBackground: Color(red: 0.90, green: 0.26, blue: 0.22).opacity(0.10),
            title: "Log out",
            subtitle: "Sign out of this device",
            rowType: .destructive
        ),
    ]}

    private var supportRows: [SettingsRowItem] {[
        SettingsRowItem(
            icon: "questionmark.circle.fill",
            iconColor: Color(red: 0.38, green: 0.38, blue: 0.88),
            iconBackground: Color(red: 0.38, green: 0.38, blue: 0.88).opacity(0.12),
            title: "Help & Support",
            subtitle: "Get assistance or contact support",
            rowType: .navigate
        ),
        SettingsRowItem(
            icon: "info.circle.fill",
            iconColor: Color(.secondaryLabel),
            iconBackground: Color(.systemGray5),
            title: "About App",
            subtitle: "",
            rowType: .navigate
        ),
    ]}

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Group builder
    // ─────────────────────────────────────────────────────────────────────────
    private func settingsGroup(rows: [SettingsRowItem], actions: [Int: () -> Void] = [:]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.element.title) { idx, row in
                if let action = actions[idx] {
                    Button(action: action) {
                        settingsCell(row: row)
                    }
                    .buttonStyle(.plain)
                } else {
                    settingsCell(row: row)
                }

                if idx < rows.count - 1 {
                    Divider().padding(.leading, 68)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private func settingsCell(row: SettingsRowItem) -> some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(row.iconBackground)
                    .frame(width: 40, height: 40)
                Image(systemName: row.icon)
                    .scalableFont(size: 17, weight: .medium)
                    .foregroundColor(row.iconColor)
            }

            // Labels
            VStack(alignment: .leading, spacing: 2) {
                Text(row.title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(row.rowType == .destructive
                                     ? Color(red: 0.90, green: 0.26, blue: 0.22)
                                     : .primary)
                if !row.subtitle.isEmpty {
                    Text(row.subtitle)
                        .scalableFont(size: 12)
                        .foregroundColor(Color(.secondaryLabel))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Trailing
            if row.rowType == .toggle {
                Toggle("", isOn: Binding(
                    get: { faceIDEnabled },
                    set: { newVal in withAnimation(.none) { faceIDEnabled = newVal } }
                ))
                    .labelsHidden()
                    .tint(.brand)
                    .animation(.none, value: faceIDEnabled)
            } else {
                Image(systemName: "chevron.right")
                    .scalableFont(size: 12, weight: .semibold)
                    .foregroundColor(Color(.tertiaryLabel))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

}

// MARK: - Row model (value type, no Binding needed)
private struct SettingsRowItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    var rowType: RowTypeValue = .navigate

    enum RowTypeValue {
        case navigate, toggle, destructive
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
