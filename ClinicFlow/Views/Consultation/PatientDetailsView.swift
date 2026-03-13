import SwiftUI

struct PatientDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileStore: UserProfileStore

    // Form state
    @State private var fullName: String        = ""
    @State private var age: String             = ""
    @State private var selectedGender: String  = ""
    @State private var nickName: String        = ""
    @State private var guardianName: String    = ""
    @State private var allergies: String       = ""

    // UI state
    var onDone: (() -> Void)? = nil
    @State private var selectedFamilyProfileID: UUID? = nil
    @State private var showProfilePicker    = false
    @State private var showGenderPicker     = false
    @State private var navigateToSpecialist = false
    @State private var validationError: String = ""
    @FocusState private var focusedField: FormField?

    enum FormField { case fullName, age, nickName, guardian, allergies }

    let genders  = ["Male", "Female", "Other"]

    // MARK: - Validation

    private var ageValue: Int? {
        Int(age.trimmingCharacters(in: .whitespaces))
    }

    private var requiresGuardian: Bool {
        guard let ageNum = ageValue else { return false }
        return ageNum < 18 || ageNum > 60
    }

    private var isFormValid: Bool {
        let hasProfile = selectedFamilyProfileID != nil || !fullName.trimmingCharacters(in: .whitespaces).isEmpty
        let hasName = !fullName.trimmingCharacters(in: .whitespaces).isEmpty
        let hasAge = !age.trimmingCharacters(in: .whitespaces).isEmpty
        let hasGender = !selectedGender.isEmpty
        let guardianValid = !requiresGuardian || !guardianName.trimmingCharacters(in: .whitespaces).isEmpty

        return hasName && hasAge && hasGender && guardianValid
    }

    private var selectedProfileLabel: String {
        guard let id = selectedFamilyProfileID,
              let p = profileStore.familyProfiles.first(where: { $0.id == id }) else { return "None" }
        return "\(p.firstName) \(p.lastName)"
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            infoBanner

                            // ── Personal Information ──────────────────────
                            sectionLabel("Personal Information")

                            formCard {
                                // Profile
                                fieldRow(icon: "person.2.circle.fill",
                                         iconColor: Color(red: 0.35, green: 0.55, blue: 0.95),
                                         label: "Profile", required: true) {
                                    pickerRowContent(value: selectedProfileLabel,
                                                     placeholder: "Select a profile",
                                                     isOpen: showProfilePicker) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                                            showProfilePicker.toggle()
                                            showGenderPicker = false
                                            focusedField = nil
                                        }
                                    }
                                }
                                if showProfilePicker {
                                    rowDivider
                                    profileDropdown
                                }

                                rowDivider

                                // Full Name
                                fieldRow(icon: "person.text.rectangle.fill",
                                         iconColor: Color.brand,
                                         label: "Full Name", required: true) {
                                    TextField("Enter full name", text: $fullName)
                                        .scalableFont(size: 16)
                                        .focused($focusedField, equals: .fullName)
                                }

                                rowDivider

                                // Age
                                fieldRow(icon: "calendar.badge.clock",
                                         iconColor: Color(red: 0.90, green: 0.48, blue: 0.00),
                                         label: "Age", required: true) {
                                    HStack(spacing: 8) {
                                        TextField("e.g. 32", text: $age)
                                            .scalableFont(size: 16)
                                            .keyboardType(.numberPad)
                                            .focused($focusedField, equals: .age)
                                        Text("yrs")
                                            .scalableFont(size: 12, weight: .semibold)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Color(.systemGray5))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }

                                rowDivider

                                // Gender
                                fieldRow(icon: "person.fill.questionmark",
                                         iconColor: Color(red: 0.60, green: 0.35, blue: 0.90),
                                         label: "Gender", required: true) {
                                    pickerRowContent(value: selectedGender,
                                                     placeholder: "Select gender",
                                                     isOpen: showGenderPicker) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                                            showGenderPicker.toggle()
                                            showProfilePicker = false
                                            focusedField = nil
                                        }
                                    }
                                }
                                if showGenderPicker {
                                    rowDivider
                                    genderDropdown
                                }

                                rowDivider

                                // Nick Name
                                fieldRow(icon: "tag.fill",
                                         iconColor: Color(red: 0.15, green: 0.68, blue: 0.48),
                                         label: "Nick Name", required: false) {
                                    TextField("Optional", text: $nickName)
                                        .scalableFont(size: 16)
                                        .focused($focusedField, equals: .nickName)
                                }
                            }

                            // ── Guardian Details ──────────────────────────
                            sectionLabel("Guardian Details")

                            formCard {
                                fieldRow(icon: "person.badge.shield.checkmark.fill",
                                         iconColor: Color(red: 0.88, green: 0.32, blue: 0.32),
                                         label: "Guardian Name", required: requiresGuardian) {
                                    TextField("Enter guardian name", text: $guardianName)
                                        .scalableFont(size: 16)
                                        .focused($focusedField, equals: .guardian)
                                }
                            }

                            // Warning card
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .scalableFont(size: 15)
                                    .foregroundColor(.orange)
                                    .padding(.top, 1)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Safety Requirement")
                                        .scalableFont(size: 12, weight: .semibold)
                                        .foregroundColor(Color(red: 0.70, green: 0.35, blue: 0.00))
                                    Text("Users below 18 or above 60 years of age must provide guardian details before continuing.")
                                        .scalableFont(size: 12)
                                        .foregroundColor(Color(.secondaryLabel))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 1.0, green: 0.94, blue: 0.80))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.orange.opacity(0.30), lineWidth: 1)
                            )

                            // ── Medical Information ───────────────────────
                            sectionLabel("Medical Information")

                            formCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "cross.case.fill")
                                            .scalableFont(size: 15)
                                            .foregroundColor(Color(red: 0.85, green: 0.20, blue: 0.25))
                                            .frame(width: 34, height: 34)
                                            .background(Color(red: 0.85, green: 0.20, blue: 0.25).opacity(0.10))
                                            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                                        VStack(alignment: .leading, spacing: 1) {
                                            HStack(spacing: 2) {
                                                Text("Allergies")
                                                    .scalableFont(size: 11, weight: .semibold)
                                                    .foregroundColor(Color(.secondaryLabel))
                                                    .textCase(.uppercase)
                                                    .kerning(0.2)
                                            }
                                            Text("List known allergies")
                                                .scalableFont(size: 15)
                                                .foregroundColor(Color(.placeholderText))
                                                .frame(height: allergies.isEmpty ? nil : 0)
                                                .opacity(allergies.isEmpty ? 1 : 0)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 14)
                                    .padding(.bottom, 4)

                                    ZStack(alignment: .topLeading) {
                                        if allergies.isEmpty {
                                            Text("e.g. nuts, latex, penicillin…")
                                                .scalableFont(size: 15)
                                                .foregroundColor(Color(.placeholderText))
                                                .padding(.horizontal, 16)
                                                .padding(.top, 4)
                                                .allowsHitTesting(false)
                                        }
                                        TextEditor(text: $allergies)
                                            .scalableFont(size: 15)
                                            .padding(.horizontal, 12)
                                            .scrollContentBackground(.hidden)
                                            .frame(minHeight: 90)
                                            .focused($focusedField, equals: .allergies)
                                    }

                                    Divider().padding(.horizontal, 16)
                                    Text("Type \"None\" if there are no known allergies.")
                                        .scalableFont(size: 12)
                                        .foregroundColor(Color(.tertiaryLabel))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                }
                            }

                            // Validation error message
                            if requiresGuardian && guardianName.trimmingCharacters(in: .whitespaces).isEmpty {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .scalableFont(size: 15)
                                        .foregroundColor(.red)
                                        .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Guardian Details Required")
                                            .scalableFont(size: 12, weight: .semibold)
                                            .foregroundColor(.red)
                                        Text("Please provide guardian name for users below 18 or above 60 years old.")
                                            .scalableFont(size: 12)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    Spacer()
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.red.opacity(0.25), lineWidth: 1)
                                )
                            }

                            // Save & Continue button
                            Button {
                                if isFormValid {
                                    savePatientToProfiles()
                                    navigateToSpecialist = true
                                }
                            } label: {
                                Text("Save & Continue")
                                    .scalableFont(size: 16, weight: .semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(isFormValid ? Color.brand : Color.brand.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .shadow(color: isFormValid ? Color.brand.opacity(0.28) : Color.clear, radius: 10, x: 0, y: 4)
                            }
                            .disabled(!isFormValid)
                            .padding(.top, 8)

                            HStack(spacing: 4) {
                                Image(systemName: "lock.fill").scalableFont(size: 10)
                                Text("Your details are securely stored and used only for your medical booking")
                                    .scalableFont(size: 11)
                            }
                            .foregroundColor(Color(.secondaryLabel))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 110)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 18)
                        .padding(.bottom, 16)
                    }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture { focusedField = nil }
        .clinicNavBar(title: "Patient Details", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToSpecialist) {
            SpecialistView(onDone: onDone)
        }
    }

    // MARK: - Save to profiles

    private static let avatarColors: [Color] = [
        Color(red: 0.26, green: 0.52, blue: 0.96),
        Color(red: 0.14, green: 0.66, blue: 0.38),
        Color(red: 0.82, green: 0.30, blue: 0.22),
        Color(red: 0.58, green: 0.28, blue: 0.86),
        Color(red: 0.90, green: 0.55, blue: 0.10),
        Color(red: 0.18, green: 0.60, blue: 0.60),
    ]

    private func savePatientToProfiles() {
        let parts     = fullName.trimmingCharacters(in: .whitespaces).split(separator: " ", maxSplits: 1)
        let firstName = parts.first.map(String.init) ?? fullName
        let lastName  = parts.count > 1 ? String(parts[1]) : ""

        if let id = selectedFamilyProfileID,
           let idx = profileStore.familyProfiles.firstIndex(where: { $0.id == id }) {
            // ── Update the selected existing profile ───────────────────────
            profileStore.familyProfiles[idx].firstName    = firstName
            profileStore.familyProfiles[idx].lastName     = lastName
            profileStore.familyProfiles[idx].gender       = selectedGender.isEmpty ? profileStore.familyProfiles[idx].gender : selectedGender
            profileStore.familyProfiles[idx].age          = age
            profileStore.familyProfiles[idx].nickName     = nickName
            profileStore.familyProfiles[idx].guardianName = guardianName
            profileStore.familyProfiles[idx].allergies    = allergies
        } else if !fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            // ── No profile selected → create a new one ─────────────────────
            let color = Self.avatarColors[profileStore.familyProfiles.count % Self.avatarColors.count]
            let newProfile = FamilyProfile(
                firstName:    firstName,
                lastName:     lastName,
                relation:     "Other",
                gender:       selectedGender.isEmpty ? "Male" : selectedGender,
                bloodType:    "O+",
                phone:        "",
                color:        color,
                age:          age,
                nickName:     nickName,
                guardianName: guardianName,
                allergies:    allergies
            )
            profileStore.familyProfiles.append(newProfile)
            selectedFamilyProfileID = newProfile.id
        }
        
        // ── Save patient details to ProfileStore for profile creation ──────
        profileStore.patientFullName = fullName
        profileStore.patientGender = selectedGender
        profileStore.age = age
        profileStore.nickName = nickName
        profileStore.guardianName = guardianName
        profileStore.allergies = allergies
    }

    // MARK: - Autofill

    private func autofill(from profile: FamilyProfile) {
        fullName       = "\(profile.firstName) \(profile.lastName)".trimmingCharacters(in: .whitespaces)
        selectedGender = profile.gender
        age            = profile.age
        nickName       = profile.nickName
        guardianName   = profile.guardianName
        allergies      = profile.allergies
    }

    // MARK: - Info Banner

    private var infoBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "doc.text.fill")
                .scalableFont(size: 20)
                .foregroundColor(Color.brand)
                .frame(width: 44, height: 44)
                .background(Color.brand.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text("Appointment Details")
                    .scalableFont(size: 14, weight: .semibold)
                    .foregroundColor(.primary)
                Text("Please fill in accurate details for this booking.")
                    .scalableFont(size: 12)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            Image(systemName: "info.circle")
                .scalableFont(size: 16)
                .foregroundColor(Color.brand.opacity(0.55))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.brand.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.brand.opacity(0.18), lineWidth: 1)
        )
    }

    // MARK: - Section / Card Helpers

    private func sectionLabel(_ title: String) -> some View {
        Text(title.uppercased())
            .scalableFont(size: 11, weight: .semibold)
            .foregroundColor(Color(.secondaryLabel))
            .kerning(0.4)
            .padding(.leading, 4)
            .padding(.bottom, -8)
    }

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }

    private var rowDivider: some View {
        Divider().padding(.leading, 62)
    }

    // MARK: - Field Row

    private func fieldRow<Content: View>(
        icon: String, iconColor: Color, label: String, required: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(iconColor)
                .frame(width: 34, height: 34)
                .background(iconColor.opacity(0.11))
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 2) {
                    Text(label)
                        .scalableFont(size: 11, weight: .semibold)
                        .foregroundColor(Color(.secondaryLabel))
                        .textCase(.uppercase)
                        .kerning(0.2)
                    if required {
                        Text("*")
                            .scalableFont(size: 12, weight: .bold)
                            .foregroundColor(Color.brand.opacity(0.8))
                    }
                }
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func pickerRowContent(value: String, placeholder: String, isOpen: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(value.isEmpty || value == "None" ? placeholder : value)
                    .scalableFont(size: 16)
                    .foregroundColor(value.isEmpty || value == "None" ? Color(.placeholderText) : .primary)
                Spacer()
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .scalableFont(size: 12, weight: .semibold)
                    .foregroundColor(isOpen ? Color.brand : Color(.tertiaryLabel))
                    .animation(.easeInOut(duration: 0.2), value: isOpen)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Profile Dropdown

    private var profileDropdown: some View {
        let relationIconMap: [String: (String, Color)] = [
            "Self":        ("figure.stand",                  Color.brand),
            "Father":      ("person.fill",                   Color(red: 0.25, green: 0.55, blue: 0.92)),
            "Mother":      ("person.fill",                   Color(red: 0.92, green: 0.42, blue: 0.62)),
            "Sister":      ("person.fill",                   Color(red: 0.60, green: 0.35, blue: 0.92)),
            "Brother":     ("person.fill",                   Color(red: 0.18, green: 0.68, blue: 0.52)),
            "Spouse":      ("heart.fill",                    Color(red: 0.96, green: 0.36, blue: 0.48)),
            "Son":         ("person.fill",                   Color(red: 0.22, green: 0.62, blue: 0.88)),
            "Daughter":    ("person.fill",                   Color(red: 0.92, green: 0.52, blue: 0.72)),
            "Grandparent": ("person.fill",                   Color(red: 0.55, green: 0.45, blue: 0.35)),
            "Other":       ("person.fill.questionmark",      Color(.systemGray)),
        ]
        return Group {
            // "None" option
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                    selectedFamilyProfileID = nil
                    showProfilePicker = false
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "minus.circle.fill")
                        .scalableFont(size: 13)
                        .foregroundColor(Color(.systemGray3))
                        .frame(width: 28, height: 28)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                    Text("None")
                        .scalableFont(size: 15)
                        .foregroundColor(.primary)
                    Spacer()
                    if selectedFamilyProfileID == nil {
                        Image(systemName: "checkmark.circle.fill")
                            .scalableFont(size: 17)
                            .foregroundColor(.brand)
                    }
                }
                .padding(.leading, 62)
                .padding(.trailing, 16)
                .frame(height: 46)
                .background(selectedFamilyProfileID == nil ? Color.brand.opacity(0.05) : Color.clear)
            }
            .buttonStyle(.plain)

            ForEach(profileStore.familyProfiles) { profile in
                let meta = relationIconMap[profile.relation] ?? ("person.fill", Color.brand)
                let isSelected = selectedFamilyProfileID == profile.id
                Divider().padding(.leading, 62)
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                        selectedFamilyProfileID = profile.id
                        showProfilePicker = false
                    }
                    autofill(from: profile)
                } label: {
                    HStack(spacing: 12) {
                        // Avatar circle with initials
                        ZStack {
                            Circle()
                                .fill(meta.1.opacity(0.15))
                                .frame(width: 28, height: 28)
                            Text(profile.initials)
                                .scalableFont(size: 11, weight: .bold)
                                .foregroundColor(meta.1)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(profile.firstName) \(profile.lastName)")
                                .scalableFont(size: 15)
                                .foregroundColor(.primary)
                            Text(profile.relation)
                                .scalableFont(size: 11, weight: .medium)
                                .foregroundColor(meta.1)
                        }
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .scalableFont(size: 17)
                                .foregroundColor(.brand)
                        }
                    }
                    .padding(.leading, 62)
                    .padding(.trailing, 16)
                    .frame(height: 50)
                    .background(isSelected ? Color.brand.opacity(0.05) : Color.clear)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Gender Dropdown

    private var genderDropdown: some View {
        let metaMap: [String: (String, Color)] = [
            "Male":   ("person.fill",              Color(red: 0.22, green: 0.52, blue: 0.96)),
            "Female": ("person.fill",              Color(red: 0.96, green: 0.42, blue: 0.64)),
            "Other":  ("person.fill.questionmark", Color(red: 0.60, green: 0.35, blue: 0.90)),
        ]
        return Group {
            ForEach(genders, id: \.self) { g in
                let m = metaMap[g] ?? ("person.fill", Color.brand)
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                        selectedGender = g
                        showGenderPicker = false
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: m.0)
                            .scalableFont(size: 13)
                            .foregroundColor(m.1)
                            .frame(width: 28, height: 28)
                            .background(m.1.opacity(0.12))
                            .clipShape(Circle())
                        Text(g)
                            .scalableFont(size: 15)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedGender == g {
                            Image(systemName: "checkmark.circle.fill")
                                .scalableFont(size: 17)
                                .foregroundColor(Color.brand)
                        }
                    }
                    .padding(.leading, 62)
                    .padding(.trailing, 16)
                    .frame(height: 46)
                    .background(selectedGender == g ? Color.brand.opacity(0.05) : Color.clear)
                }
                .buttonStyle(.plain)
                if g != genders.last { Divider().padding(.leading, 62) }
            }
        }
    }

}

#Preview { PatientDetailsView().environmentObject(UserProfileStore()) }
