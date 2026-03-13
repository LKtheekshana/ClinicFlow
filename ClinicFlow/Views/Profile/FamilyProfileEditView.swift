import SwiftUI

/// Edit view for a single family-member profile (non-Self).
/// Receives a direct Binding into the store's familyProfiles array.
struct FamilyProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var profile: FamilyProfile

    @State private var isSaving    = false
    @State private var showSuccess = false

    private let relations  = ["Self", "Father", "Mother", "Brother", "Sister",
                               "Spouse", "Son", "Daughter", "Grandparent", "Other"]
    private let genders    = ["Male", "Female", "Other"]
    private let bloodTypes = ["A+", "A−", "B+", "B−", "AB+", "AB−", "O+", "O−"]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            avatarSection
                                .padding(.bottom, 28)

                            formSection(title: "Personal Information") {
                                formField(label: "First Name", value: $profile.firstName, icon: "person")
                                divider
                                formField(label: "Last Name",  value: $profile.lastName,  icon: "person")
                                divider
                                formField(label: "Phone",      value: $profile.phone,     icon: "phone", keyboard: .phonePad)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            formSection(title: "Medical Information") {
                                pickerField(label: "Gender",     value: $profile.gender,    icon: "person.2",
                                            options: genders)
                                divider
                                pickerField(label: "Blood Type", value: $profile.bloodType, icon: "drop.fill",
                                            options: bloodTypes,
                                            valueColor: Color(red: 0.82, green: 0.16, blue: 0.16))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            formSection(title: "Patient Details") {
                                formField(label: "Age",           value: $profile.age,          icon: "calendar.badge.clock", keyboard: .numberPad)
                                divider
                                formField(label: "Nick Name",     value: $profile.nickName,     icon: "tag")
                                divider
                                formField(label: "Guardian Name", value: $profile.guardianName, icon: "person.badge.shield.checkmark")
                                divider
                                textAreaField(label: "Allergies", value: $profile.allergies,    icon: "cross.case")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            formSection(title: "Relation") {
                                pickerField(label: "Relation", value: $profile.relation, icon: "figure.2.and.child.holdinghands",
                                            options: relations)
                            }
                            .padding(.horizontal, 20)

                            Spacer(minLength: 110 + geo.safeAreaInsets.bottom)
                        }
                    }

                    saveBar(geo: geo)
                }
            }
        }
        .clinicNavBar(title: "Edit Profile", onBack: { dismiss() })
    }

    // MARK: - Avatar

    private var avatarSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [profile.color, profile.color.opacity(0.70)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .shadow(color: profile.color.opacity(0.28), radius: 12, x: 0, y: 6)
                Text(profile.initials)
                    .scalableFont(size: 32, weight: .bold)
                    .foregroundColor(.white)
            }

            VStack(spacing: 3) {
                Text("\(profile.firstName) \(profile.lastName)")
                    .scalableFont(size: 18, weight: .bold)
                    .foregroundColor(.primary)
                Text(profile.relation)
                    .scalableFont(size: 13)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
    }

    // MARK: - Form helpers

    private func formSection<C: View>(title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .scalableFont(size: 13, weight: .semibold)
                .foregroundColor(Color(.secondaryLabel))
                .textCase(.uppercase)
                .kerning(0.4)
                .padding(.leading, 4)

            VStack(spacing: 0) { content() }
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                )
        }
    }

    private func formField(label: String, value: Binding<String>, icon: String,
                           keyboard: UIKeyboardType = .default) -> some View {
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
                    .scalableFont(size: 15)
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

    private func pickerField(label: String, value: Binding<String>, icon: String,
                             options: [String], valueColor: Color = .primary) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .scalableFont(size: 11, weight: .medium)
                    .foregroundColor(Color(.tertiaryLabel))
                Picker("", selection: value) {
                    ForEach(options, id: \.self) { Text($0).tag($0) }
                }
                .labelsHidden()
                .tint(valueColor == .primary ? .brand : valueColor)
                .padding(.leading, -8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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

    // MARK: - Save bar

    private func saveBar(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 0.8)

            Button(action: {
                withAnimation { isSaving = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isSaving = false
                    showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        showSuccess = false
                    }
                }
            }) {
                HStack(spacing: 8) {
                    if isSaving {
                        ProgressView().tint(.white).scaleEffect(0.85)
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

#Preview {
    let store = UserProfileStore()
    return FamilyProfileEditView(profile: .constant(store.familyProfiles[0]))
}
