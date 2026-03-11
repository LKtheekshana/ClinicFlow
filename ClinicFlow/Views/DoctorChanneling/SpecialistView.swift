import SwiftUI

struct SpecialistView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var selectedCategory     = "Dermatologist"
    @State private var navigateToDoctorChanneling = false
    @State private var navigateToDoctorProfile    = false

    private let categories = ["Dermatologist", "Heart Surgeon", "Neurologist"]

    private let specialists: [Specialist] = [
        Specialist(name: "Dr. Sarah Johnson",   subtitle: "MBBS, Dermatologist specialist",    rating: 5, reviews: 124, imageSymbol: "person.crop.circle.fill.badge.checkmark", experience: "8 yrs", available: true),
        Specialist(name: "Dr. Michael Chen",    subtitle: "MBBS, MD, Dermatologist specialist", rating: 4, reviews: 89,  imageSymbol: "person.crop.circle.fill.badge.plus",       experience: "12 yrs", available: true),
        Specialist(name: "Dr. Emily Rodriguez", subtitle: "MBBS, Dermatologist specialist",    rating: 5, reviews: 156, imageSymbol: "person.crop.circle.fill",                  experience: "6 yrs",  available: false),
        Specialist(name: "Dr. David Thompson",  subtitle: "MBBS, MD, Dermatologist specialist", rating: 4, reviews: 73,  imageSymbol: "person.crop.circle.fill.badge.checkmark", experience: "10 yrs", available: true),
    ]

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                categorySection
                Divider()
                resultsMeta
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(.systemGroupedBackground))

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 14) {
                        ForEach(specialists) { s in
                            SpecialistCard(specialist: s) {
                                navigateToDoctorProfile = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
            }
        }
        .clinicNavBar(title: "Find a Specialist", onBack: { dismiss() }) {
            ToolbarCircleButton(icon: "magnifyingglass", action: { navigateToDoctorChanneling = true })
        }
        .navigationDestination(isPresented: $navigateToDoctorChanneling) {
            DoctorChannelingView(onDone: onDone)
        }
        .navigationDestination(isPresented: $navigateToDoctorProfile) {
            DoctorProfileView(onDone: onDone)
        }
    }

    // MARK: - Category Tabs

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Specialty")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(.secondaryLabel))
                .kerning(0.4)
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { cat in
                        Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selectedCategory = cat } } label: {
                            HStack(spacing: 6) {
                                Image(systemName: iconFor(cat))
                                    .font(.system(size: 12, weight: .semibold))
                                Text(cat)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(selectedCategory == cat ? .white : Color(.label))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(selectedCategory == cat ? Color.brand : Color(.systemBackground))
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(selectedCategory == cat ? Color.clear : Color(.systemGray4), lineWidth: 1)
                            )
                            .shadow(color: selectedCategory == cat ? Color.brand.opacity(0.28) : .clear, radius: 8, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
            }
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Results Meta

    private var resultsMeta: some View {
        HStack {
            Text("\(specialists.count) specialists found")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(.secondaryLabel))
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 13, weight: .medium))
                Text("Filter")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(Color.brand)
        }
    }

    // MARK: - Helpers

    private func iconFor(_ cat: String) -> String {
        switch cat {
        case "Heart Surgeon": return "heart.fill"
        case "Neurologist":   return "brain.head.profile"
        default:              return "allergens"
        }
    }
}

// MARK: - Specialist Card

private struct SpecialistCard: View {
    let specialist: Specialist
    let onTap: () -> Void

    // Gradient colors cycle through brand-adjacent hues for each doctor
    private let gradients: [[Color]] = [
        [Color(red: 0.00, green: 0.40, blue: 0.73), Color(red: 0.20, green: 0.60, blue: 0.90)],
        [Color(red: 0.36, green: 0.22, blue: 0.78), Color(red: 0.58, green: 0.40, blue: 0.96)],
        [Color(red: 0.10, green: 0.62, blue: 0.52), Color(red: 0.24, green: 0.80, blue: 0.68)],
        [Color(red: 0.85, green: 0.32, blue: 0.28), Color(red: 0.98, green: 0.55, blue: 0.42)],
    ]

    private static var gradientIndex = 0

    private var gradient: [Color] {
        let idx = (gradients.count > 0) ? abs(specialist.name.hash) % gradients.count : 0
        return gradients[idx]
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Top: avatar + info
                HStack(alignment: .top, spacing: 14) {
                    // Avatar
                    Image("doctor_placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 62, height: 62)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.brand.opacity(0.25), radius: 8, x: 0, y: 4)

                    // Text info
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .top) {
                            Text(specialist.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(.label))
                            Spacer()
                            availabilityBadge
                        }

                        Text(specialist.subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(Color(.secondaryLabel))
                            .lineSpacing(2)

                        HStack(spacing: 10) {
                            // Stars
                            HStack(spacing: 3) {
                                ForEach(0..<5, id: \.self) { i in
                                    Image(systemName: i < specialist.rating ? "star.fill" : "star")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Color(red: 0.98, green: 0.76, blue: 0.12))
                                }
                                Text("(\(specialist.reviews))")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.tertiaryLabel))
                                    .padding(.leading, 2)
                            }

                            Spacer()

                            // Experience badge
                            HStack(spacing: 3) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10, weight: .semibold))
                                Text(specialist.experience)
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                Divider().padding(.horizontal, 16)

                // Bottom: action strip
                HStack(spacing: 0) {
                    Button(action: onTap) {
                        HStack(spacing: 6) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 13, weight: .medium))
                            Text("View Profile")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(Color.brand)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                    }
                    .buttonStyle(.plain)

                    Divider().frame(height: 28)

                    Button(action: onTap) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 13, weight: .medium))
                            Text("Book Now")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(specialist.available ? Color.brand : Color(.systemGray3))
                    }
                    .buttonStyle(.plain)
                    .disabled(!specialist.available)
                }
                .clipShape(
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 14,
                                           bottomTrailingRadius: 14, topTrailingRadius: 0,
                                           style: .continuous)
                )
            }
        }
        .buttonStyle(.plain)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 3)
    }

    private var availabilityBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(specialist.available ? Color(red: 0.18, green: 0.72, blue: 0.46) : Color(.systemGray3))
                .frame(width: 6, height: 6)
            Text(specialist.available ? "Available" : "Unavailable")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(specialist.available ? Color(red: 0.10, green: 0.58, blue: 0.36) : Color(.secondaryLabel))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(specialist.available ? Color(red: 0.18, green: 0.72, blue: 0.46).opacity(0.10) : Color(.systemGray5))
        .clipShape(Capsule())
    }
}

// MARK: - Model

private struct Specialist: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let rating: Int
    let reviews: Int
    let imageSymbol: String
    let experience: String
    let available: Bool
}

#Preview {
    SpecialistView()
}
