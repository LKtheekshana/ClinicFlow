import SwiftUI

// FamilyProfile model lives in Models/FamilyProfile.swift

// MARK: - Add Profile Sheet
struct AddProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileStore: UserProfileStore
    @Binding var profiles: [FamilyProfile]

    @State private var firstName  = ""
    @State private var lastName   = ""
    @State private var relation   = "Family Member"
    @State private var gender     = "Male"
    @State private var bloodType  = "O+"
    @State private var phone      = ""
    @State private var age        = ""
    @State private var nickName   = ""
    @State private var guardianName = ""
    @State private var allergies  = ""

    private let relations  = ["Self", "Father", "Mother", "Brother", "Sister",
                               "Spouse", "Son", "Daughter", "Grandparent", "Other"]
    private let genders    = ["Male", "Female", "Other"]
    private let bloodTypes = ["A+", "A−", "B+", "B−", "AB+", "AB−", "O+", "O−"]

    private let avatarColors: [Color] = [
        Color(red: 0.26, green: 0.52, blue: 0.96),
        Color(red: 0.14, green: 0.66, blue: 0.38),
        Color(red: 0.82, green: 0.30, blue: 0.22),
        Color(red: 0.58, green: 0.28, blue: 0.86),
        Color(red: 0.90, green: 0.55, blue: 0.10),
        Color(red: 0.18, green: 0.60, blue: 0.60),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Preview avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [avatarColor, avatarColor.opacity(0.70)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(color: avatarColor.opacity(0.35), radius: 10, x: 0, y: 5)
                        Text(previewInitials)
                            .scalableFont(size: 26, weight: .bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 8)

                    // Fields
                    sheetSection(title: "Basic Info") {
                        sheetField(label: "First Name", text: $firstName, icon: "person",     keyboard: .default)
                        sheetDivider
                        sheetField(label: "Last Name",  text: $lastName,  icon: "person",     keyboard: .default)
                        sheetDivider
                        sheetField(label: "Phone",      text: $phone,     icon: "phone",      keyboard: .phonePad)
                    }

                    sheetSection(title: "Relationship & Medical") {
                        sheetPicker(label: "Relation",   value: $relation,   icon: "person.2",        options: relations)
                        sheetDivider
                        sheetPicker(label: "Gender",     value: $gender,     icon: "person.crop.circle", options: genders)
                        sheetDivider
                        sheetPicker(label: "Blood Type", value: $bloodType,  icon: "drop.fill",       options: bloodTypes)
                    }

                    sheetSection(title: "Medical Details") {
                        sheetField(label: "Age",      text: $age,      icon: "calendar.badge.clock",  keyboard: .numberPad)
                        sheetDivider
                        sheetField(label: "Nick Name", text: $nickName, icon: "tag.fill",             keyboard: .default)
                        sheetDivider
                        sheetField(label: "Guardian Name", text: $guardianName, icon: "person.badge.shield.checkmark.fill", keyboard: .default)
                    }

                    sheetSection(title: "Allergies") {
                        sheetField(label: "Allergies", text: $allergies, icon: "cross.case.fill", keyboard: .default)
                    }

                    // Save
                    Button(action: saveProfile) {
                        Text(firstName.isEmpty && lastName.isEmpty ? "Fill in a name to save" : "Add Profile")
                            .scalableFont(size: 16, weight: .semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(firstName.isEmpty ? Color(.systemGray3) : Color.brand)
                            )
                            .shadow(color: firstName.isEmpty ? .clear : Color.brand.opacity(0.28),
                                    radius: 10, x: 0, y: 4)
                    }
                    .disabled(firstName.isEmpty)
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationTitle("New Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                // Pre-fill with patient data from ProfileStore if available
                if !profileStore.patientFullName.isEmpty {
                    let parts = profileStore.patientFullName.split(separator: " ", maxSplits: 1)
                    firstName = parts.first.map(String.init) ?? ""
                    lastName = parts.count > 1 ? String(parts[1]) : ""
                    gender = profileStore.patientGender.isEmpty ? "Male" : profileStore.patientGender
                    age = profileStore.age
                    nickName = profileStore.nickName
                    guardianName = profileStore.guardianName
                    allergies = profileStore.allergies
                }
            }
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private var previewInitials: String {
        let f = firstName.prefix(1).uppercased()
        let l = lastName.prefix(1).uppercased()
        let i = "\(f)\(l)"
        return i.isEmpty ? "?" : i
    }

    private var avatarColor: Color {
        avatarColors[(profiles.count) % avatarColors.count]
    }

    private func saveProfile() {
        guard !firstName.isEmpty else { return }
        let p = FamilyProfile(
            firstName: firstName, lastName: lastName,
            relation: relation, gender: gender,
            bloodType: bloodType, phone: phone,
            color: avatarColor,
            age: age,
            nickName: nickName,
            guardianName: guardianName,
            allergies: allergies
        )
        profiles.append(p)
        dismiss()
    }

    private func sheetSection<C: View>(title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .scalableFont(size: 12, weight: .semibold)
                .foregroundColor(Color(.secondaryLabel))
                .textCase(.uppercase)
                .kerning(0.4)
                .padding(.leading, 4)
            VStack(spacing: 0) { content() }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                )
        }
    }

    private func sheetField(label: String, text: Binding<String>, icon: String, keyboard: UIKeyboardType) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .scalableFont(size: 14, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).scalableFont(size: 11).foregroundColor(Color(.tertiaryLabel))
                TextField(label, text: text)
                    .scalableFont(size: 15)
                    .keyboardType(keyboard)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }

    private func sheetPicker(label: String, value: Binding<String>, icon: String, options: [String]) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .scalableFont(size: 14, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 20)
            Text(label)
                .scalableFont(size: 15)
                .foregroundColor(.primary)
            Spacer()
            Picker("", selection: value) {
                ForEach(options, id: \.self) { Text($0).tag($0) }
            }
            .labelsHidden()
            .tint(.brand)
        }
        .padding(.horizontal, 16).padding(.vertical, 6)
    }

    private var sheetDivider: some View {
        Rectangle().fill(Color(.systemGray5)).frame(height: 0.8).padding(.leading, 48)
    }
}

// MARK: - All Profiles View
struct AllProfilesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileStore: UserProfileStore

    @State private var showAddSheet         = false
    @State private var navigateToSelfEdit   = false
    @State private var navigateToFamilyEdit = false
    @State private var selectedProfile: FamilyProfile? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Section label
                Text("All Profiles")
                    .scalableFont(size: 13, weight: .semibold)
                    .foregroundColor(Color(.secondaryLabel))
                    .textCase(.uppercase)
                    .kerning(0.4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)

                // Profile cards
                VStack(spacing: 12) {
                    ForEach(profileStore.familyProfiles) { profile in
                        profileCard(profile: profile)
                            .padding(.horizontal, 20)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedProfile = profile
                                if profile.relation == "Self" {
                                    navigateToSelfEdit = true
                                } else {
                                    navigateToFamilyEdit = true
                                }
                            }
                    }
                }

                // Add profile row
                addProfileRow
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
            }
            .padding(.bottom, 110)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            Button(action: { showAddSheet = true }) {
                ZStack {
                    Circle()
                        .fill(Color.brand)
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.brand.opacity(0.38), radius: 14, x: 0, y: 6)
                    Image(systemName: "plus")
                        .scalableFont(size: 22, weight: .bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 24)
            .padding(.bottom, 90)
        }
        .clinicNavBar(title: "Profiles", onBack: { dismiss() }) {
            Text("\(profileStore.familyProfiles.count) profile\(profileStore.familyProfiles.count == 1 ? "" : "s")")
                .scalableFont(size: 13, weight: .medium)
                .foregroundColor(Color(.secondaryLabel))
        }
        .sheet(isPresented: $showAddSheet) {
            AddProfileSheet(profiles: $profileStore.familyProfiles)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $navigateToSelfEdit) {
            UserProfileView()
        }
        .navigationDestination(isPresented: $navigateToFamilyEdit) {
            if let selected = selectedProfile,
               let idx = profileStore.familyProfiles.firstIndex(where: { $0.id == selected.id }) {
                FamilyProfileEditView(profile: $profileStore.familyProfiles[idx])
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Profile card
    // ─────────────────────────────────────────────────────────────────────────
    private func profileCard(profile: FamilyProfile) -> some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [profile.color, profile.color.opacity(0.70)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: profile.color.opacity(0.28), radius: 8, x: 0, y: 3)
                Text(profile.initials)
                    .scalableFont(size: 18, weight: .bold)
                    .foregroundColor(.white)
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text("\(profile.firstName) \(profile.lastName)")
                        .scalableFont(size: 15, weight: .semibold)
                        .foregroundColor(.primary)
                    // Relation badge
                    Text(profile.relation)
                        .scalableFont(size: 10, weight: .semibold)
                        .foregroundColor(profile.relation == "Self" ? .brand : Color(.secondaryLabel))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(profile.relation == "Self"
                                      ? Color.brand.opacity(0.10)
                                      : Color(.systemGray5))
                        )
                }
                HStack(spacing: 12) {
                    Label(profile.gender, systemImage: "person")
                        .scalableFont(size: 12)
                        .foregroundColor(Color(.secondaryLabel))
                    Label(profile.bloodType, systemImage: "drop.fill")
                        .scalableFont(size: 12)
                        .foregroundColor(Color(red: 0.80, green: 0.14, blue: 0.14))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .scalableFont(size: 12, weight: .semibold)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.063), radius: 10, x: 0, y: 4)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Add profile row
    // ─────────────────────────────────────────────────────────────────────────
    private var addProfileRow: some View {
        Button(action: { showAddSheet = true }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.brand.opacity(0.50), lineWidth: 1.5, antialiased: true)
                        .background(Circle().fill(Color.brand.opacity(0.06)))
                        .frame(width: 52, height: 52)
                    Image(systemName: "plus")
                        .scalableFont(size: 20, weight: .semibold)
                        .foregroundColor(.brand)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Add Family Member")
                        .scalableFont(size: 15, weight: .semibold)
                        .foregroundColor(.brand)
                    Text("Father, Mother, Brother, Sister…")
                        .scalableFont(size: 12)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .scalableFont(size: 12, weight: .semibold)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.brand.opacity(0.20), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    AllProfilesView()
        .environmentObject(UserProfileStore())
}
