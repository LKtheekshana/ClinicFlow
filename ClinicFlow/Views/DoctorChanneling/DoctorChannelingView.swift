import SwiftUI

struct DoctorChannelingView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil

    @State private var doctorName           = "Mohan Silva"
    @State private var specialization       = "Dermatologist"
    @State private var dateText             = "18/03/2026"
    @State private var selectedDate         = Calendar.current.date(byAdding: .day, value: 11, to: Date()) ?? Date()
    @State private var navigateToDoctorProfile = false

    // UI state
    @State private var showSpecPicker       = false
    @State private var showDatePicker       = false
    @FocusState private var nameFieldFocused: Bool

    private let specializations = [
        "Dermatologist", "Cardiologist", "Neurologist",
        "Orthopedic", "Pediatrician", "General Physician"
    ]
    private let specIcons: [String: String] = [
        "Dermatologist":    "allergens",
        "Cardiologist":     "heart.fill",
        "Neurologist":      "brain.head.profile",
        "Orthopedic":       "figure.walk",
        "Pediatrician":     "figure.and.child.holdinghands",
        "General Physician":"cross.case.fill"
    ]
    private let specColors: [String: Color] = [
        "Dermatologist":    Color(red: 0.82, green: 0.42, blue: 0.20),
        "Cardiologist":     Color(red: 0.85, green: 0.22, blue: 0.28),
        "Neurologist":      Color(red: 0.40, green: 0.28, blue: 0.86),
        "Orthopedic":       Color(red: 0.18, green: 0.56, blue: 0.92),
        "Pediatrician":     Color(red: 0.15, green: 0.70, blue: 0.50),
        "General Physician":Color(red: 0.00, green: 0.40, blue: 0.73)
    ]

    private var formattedDate: String {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy"
        return f.string(from: selectedDate)
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                heroBanner

                // ── Search Fields ──────────────────────────
                sectionLabel("Search Criteria")

                formCard {
                    // Doctor Name
                    fieldRow(
                        icon: "stethoscope",
                        iconColor: Color.brand,
                        label: "Doctor Name"
                    ) {
                        TextField("Enter doctor name", text: $doctorName)
                            .font(.system(size: 16))
                            .focused($nameFieldFocused)
                            .submitLabel(.done)
                            .onSubmit { nameFieldFocused = false }
                    }

                    rowDivider

                    // Specialization
                    fieldRow(
                        icon: specIcons[specialization] ?? "cross.case.fill",
                        iconColor: specColors[specialization] ?? Color.brand,
                        label: "Specialization"
                    ) {
                        pickerContent(
                            value: specialization,
                            isOpen: showSpecPicker
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                                showSpecPicker.toggle()
                                showDatePicker = false
                                nameFieldFocused = false
                            }
                        }
                    }
                    if showSpecPicker { specDropdown }

                    rowDivider

                    // Date
                    fieldRow(
                        icon: "calendar",
                        iconColor: Color(red: 0.18, green: 0.62, blue: 0.48),
                        label: "Appointment Date"
                    ) {
                        pickerContent(
                            value: formattedDate,
                            isOpen: showDatePicker
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                                showDatePicker.toggle()
                                showSpecPicker = false
                                nameFieldFocused = false
                            }
                        }
                    }
                    if showDatePicker {
                        rowDivider
                        datePicker
                    }
                }

                // ── Quick Specializations ──────────────────
                sectionLabel("Popular Specialties")
                quickChips

                // ── Search Button ──────────────────────────
                Button {
                    dateText = formattedDate
                    navigateToDoctorProfile = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Search Doctors")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.brand)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color.brand.opacity(0.32), radius: 12, x: 0, y: 5)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 12)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 110)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture { nameFieldFocused = false }
        .clinicNavBar(title: "Doctor Channeling", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToDoctorProfile) {
            DoctorProfileView(onDone: onDone)
        }
    }

    // MARK: - Hero Banner

    private var heroBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "stethoscope.circle.fill")
                .font(.system(size: 38))
                .foregroundColor(Color.brand)
                .frame(width: 56, height: 56)
                .background(Color.brand.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text("Find the Right Doctor")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text("Search by name, specialty, or date for your next appointment.")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.secondaryLabel))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.brand.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.brand.opacity(0.18), lineWidth: 1)
        )
    }

    // MARK: - Quick Chips

    private var quickChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(specializations, id: \.self) { s in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            specialization = s
                            showSpecPicker = false
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: specIcons[s] ?? "cross.case.fill")
                                .font(.system(size: 11, weight: .semibold))
                            Text(s)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(specialization == s ? .white : Color(.label))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule(style: .continuous)
                                .fill(specialization == s ? (specColors[s] ?? Color.brand) : Color(.systemBackground))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(specialization == s ? Color.clear : Color(.systemGray4), lineWidth: 1)
                        )
                        .shadow(color: specialization == s ? (specColors[s] ?? Color.brand).opacity(0.28) : .clear,
                                radius: 6, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 2)
        }
    }

    // MARK: - Specialization Dropdown

    private var specDropdown: some View {
        Group {
            ForEach(specializations, id: \.self) { s in
                let col = specColors[s] ?? Color.brand
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                        specialization = s
                        showSpecPicker = false
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: specIcons[s] ?? "cross.case.fill")
                            .font(.system(size: 13))
                            .foregroundColor(col)
                            .frame(width: 28, height: 28)
                            .background(col.opacity(0.12))
                            .clipShape(Circle())
                        Text(s)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                        Spacer()
                        if specialization == s {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 17))
                                .foregroundColor(Color.brand)
                        }
                    }
                    .padding(.leading, 62)
                    .padding(.trailing, 16)
                    .frame(height: 46)
                    .background(specialization == s ? Color.brand.opacity(0.05) : Color.clear)
                }
                .buttonStyle(.plain)
                if s != specializations.last { Divider().padding(.leading, 62) }
            }
        }
    }

    // MARK: - Date Picker

    private var datePicker: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            in: Date()...,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .tint(Color.brand)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .onChange(of: selectedDate) { _ in
            dateText = formattedDate
        }
    }

    // MARK: - Reusable Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(Color(.secondaryLabel))
            .kerning(0.4)
            .padding(.leading, 4)
            .padding(.bottom, -8)
    }

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) { content() }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }

    private var rowDivider: some View {
        Divider().padding(.leading, 62)
    }

    private func fieldRow<Content: View>(
        icon: String, iconColor: Color, label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 34, height: 34)
                .background(iconColor.opacity(0.11))
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(.secondaryLabel))
                    .textCase(.uppercase)
                    .kerning(0.2)
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func pickerContent(value: String, isOpen: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isOpen ? Color.brand : Color(.tertiaryLabel))
                    .animation(.easeInOut(duration: 0.18), value: isOpen)
            }
        }
        .buttonStyle(.plain)
    }

}

#Preview {
    DoctorChannelingView()
}
