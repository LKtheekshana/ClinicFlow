import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: UserProfileStore

    @State private var isSaving    = false
    @State private var showSuccess = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Avatar
                            avatarSection
                                .padding(.bottom, 28)

                            // Personal info
                            formSection(title: "Personal Information") {
                                formField(label: "First Name",   value: $store.firstName,   icon: "person")
                                divider
                                formField(label: "Last Name",    value: $store.lastName,    icon: "person")
                                divider
                                formField(label: "Username",     value: $store.username,    icon: "at")
                                divider
                                formField(label: "Email",        value: $store.email,       icon: "envelope",    keyboard: .emailAddress)
                                divider
                                formField(label: "Phone",        value: $store.phone,       icon: "phone",       keyboard: .phonePad)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            // Medical info
                            formSection(title: "Medical Information") {
                                pickerField(label: "Date of Birth", value: $store.dateOfBirth, icon: "calendar")
                                divider
                                pickerField(label: "Gender",        value: $store.gender,      icon: "person.2")
                                divider
                                pickerField(label: "Blood Type",    value: $store.bloodType,   icon: "drop.fill",
                                            valueColor: Color(red: 0.82, green: 0.16, blue: 0.16))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            // Patient Details
                            formSection(title: "Patient Details") {
                                formField(label: "Age",          value: $store.age,          icon: "calendar.badge.clock", keyboard: .numberPad)
                                divider
                                formField(label: "Nick Name",    value: $store.nickName,     icon: "tag")
                                divider
                                formField(label: "Guardian Name",value: $store.guardianName, icon: "person.badge.shield.checkmark")
                                divider
                                textAreaField(label: "Allergies", value: $store.allergies, icon: "cross.case")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            // Address
                            formSection(title: "Address") {
                                formField(label: "City",    value: $store.city,    icon: "building.2")
                                divider
                                formField(label: "Country", value: $store.country, icon: "globe")
                            }
                            .padding(.horizontal, 20)

                            Spacer(minLength: 110 + geo.safeAreaInsets.bottom)
                        }
                    }

                    // Save button bar
                    saveBar(geo: geo)
                }
            }
        }
        .clinicNavBar(title: "My Profile", onBack: { dismiss() }) {
            Text("Edit")
                .scalableFont(size: 14, weight: .semibold)
                .foregroundColor(.brand)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Avatar
    // ─────────────────────────────────────────────────────────────────────────
    private var avatarSection: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.26, green: 0.52, blue: 0.96),
                                         Color(red: 0.18, green: 0.38, blue: 0.88)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                        .shadow(color: Color.brand.opacity(0.28), radius: 12, x: 0, y: 6)
                    Text(store.initials)
                        .scalableFont(size: 32, weight: .bold)
                        .foregroundColor(.white)
                }

                // Camera button
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color.brand)
                            .frame(width: 30, height: 30)
                            .shadow(color: Color.brand.opacity(0.40), radius: 6, x: 0, y: 3)
                        Image(systemName: "camera.fill")
                            .scalableFont(size: 13, weight: .medium)
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 4, y: 4)
            }

            VStack(spacing: 3) {
                Text(store.fullName)
                    .scalableFont(size: 18, weight: .bold)
                    .foregroundColor(.primary)
                Text("@\(store.username)")
                    .scalableFont(size: 13)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Form helpers
    // ─────────────────────────────────────────────────────────────────────────
    private func formSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .scalableFont(size: 13, weight: .semibold)
                .foregroundColor(Color(.secondaryLabel))
                .textCase(.uppercase)
                .kerning(0.4)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            )
        }
    }

    private func formField(
        label: String,
        value: Binding<String>,
        icon: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(Color(.tertiaryLabel))
                TextField(label, text: value)
                    .scalableFont(size: 15, weight: .regular)
                    .foregroundColor(.primary)
                    .keyboardType(keyboard)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "pencil")
                .scalableFont(size: 12)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private func pickerField(
        label: String,
        value: Binding<String>,
        icon: String,
        valueColor: Color = .primary
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(Color(.tertiaryLabel))
                Text(value.wrappedValue)
                    .scalableFont(size: 15, weight: .regular)
                    .foregroundColor(valueColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .scalableFont(size: 12, weight: .semibold)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .frame(height: 0.8)
            .padding(.leading, 52)
    }

    private func textAreaField(label: String, value: Binding<String>, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 22)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(Color(.tertiaryLabel))
                ZStack(alignment: .topLeading) {
                    if value.wrappedValue.isEmpty {
                        Text("e.g. nuts, latex, penicillin…")
                            .scalableFont(size: 15)
                            .foregroundColor(Color(.placeholderText))
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: value)
                        .scalableFont(size: 15)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 72)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Save bar
    // ─────────────────────────────────────────────────────────────────────────
    private func saveBar(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 0.8)

            Button(action: {
                withAnimation { isSaving = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    isSaving = false
                    showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        showSuccess = false
                    }
                }
            }) {
                HStack(spacing: 8) {
                    if isSaving {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.85)
                    } else if showSuccess {
                        Image(systemName: "checkmark")
                            .scalableFont(size: 15, weight: .bold)
                    }
                    Text(isSaving ? "Saving…" : showSuccess ? "Saved!" : "Save Changes")
                        .scalableFont(size: 16, weight: .semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(showSuccess ? Color(red: 0.14, green: 0.66, blue: 0.38) : Color.brand)
                )
                .shadow(color: (showSuccess ? Color.green : Color.brand).opacity(0.28),
                        radius: 10, x: 0, y: 4)
                .animation(.easeInOut(duration: 0.25), value: showSuccess)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, max(geo.safeAreaInsets.bottom + 8, 16))
        }
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(UserProfileStore())
}
