import SwiftUI

// MARK: - Models
private struct HospitalLocation: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let time: String
    let icon: String
    let iconColor: Color
    let bgColor: Color
}

private struct RecentLocation: Identifiable {
    let id = UUID()
    let name: String
    let when: String
}

// MARK: - Directions View
struct DirectionsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentLocation = "Main Entrance"
    @State private var selectedLocationID: UUID? = nil
    @State private var navigateToInstructions = false

    private var selectedLocationName: String {
        locations.first(where: { $0.id == selectedLocationID })?.name ?? "Lab"
    }

    private let locations: [HospitalLocation] = [
        HospitalLocation(name: "Lab",               subtitle: "Blood tests & reports", time: "Approx. 3 min", icon: "flask.fill",                  iconColor: Color(red: 0.28, green: 0.44, blue: 0.92), bgColor: Color(red: 0.28, green: 0.44, blue: 0.92).opacity(0.12)),
        HospitalLocation(name: "Pharmacy",          subtitle: "Medicine pickup",       time: "Same floor",    icon: "pills.fill",                   iconColor: Color(red: 0.20, green: 0.72, blue: 0.44), bgColor: Color(red: 0.20, green: 0.72, blue: 0.44).opacity(0.12)),
        HospitalLocation(name: "ICU",               subtitle: "Critical care unit",    time: "Approx. 5 min", icon: "heart.fill",                   iconColor: Color(red: 0.90, green: 0.28, blue: 0.32), bgColor: Color(red: 0.90, green: 0.28, blue: 0.32).opacity(0.12)),
        HospitalLocation(name: "Emergency Room",    subtitle: "Admission & triage",    time: "Different floor",icon: "cross.case.fill",              iconColor: Color(red: 0.94, green: 0.52, blue: 0.16), bgColor: Color(red: 0.94, green: 0.52, blue: 0.16).opacity(0.12)),
        HospitalLocation(name: "Operating Theater", subtitle: "Surgery department",    time: "Approx. 7 min", icon: "person.crop.circle.badge.plus", iconColor: Color(red: 0.56, green: 0.36, blue: 0.90), bgColor: Color(red: 0.56, green: 0.36, blue: 0.90).opacity(0.12)),
        HospitalLocation(name: "Ward 3B",           subtitle: "Patient rooms",         time: "Different floor",icon: "bed.double.fill",              iconColor: Color(red: 0.36, green: 0.54, blue: 0.84), bgColor: Color(red: 0.36, green: 0.54, blue: 0.84).opacity(0.12)),
    ]

    private let popularTags = ["Lab", "Pharmacy", "ICU", "Emergency"]

    private let recentLocations: [RecentLocation] = [
        RecentLocation(name: "Pharmacy", when: "Yesterday"),
        RecentLocation(name: "ICU",      when: "2 days ago"),
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                // You are at card
                locationCard

                // Choose a location
                locationsList

                // Popular destinations
                popularSection

                // Recent Locations
                recentSection

                // Start Directions button
                Button(action: { navigateToInstructions = true }) {
                    Text("Start Directions")
                        .scalableFont(size: 16, weight: .semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.brand)
                                .shadow(color: Color.brand.opacity(0.30), radius: 10, x: 0, y: 4)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 110)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Directions", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToInstructions) {
            GetDirectionView(from: currentLocation, to: selectedLocationName)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: You Are At Card
    // ─────────────────────────────────────────────────────────────────────────
    private var locationCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("You are at")
                    .scalableFont(size: 12, weight: .regular)
                    .foregroundColor(Color(.secondaryLabel))
                Text(currentLocation)
                    .scalableFont(size: 17, weight: .semibold)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {}) {
                Text("Change")
                    .scalableFont(size: 13, weight: .semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Choose a location list
    // ─────────────────────────────────────────────────────────────────────────
    private var locationsList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Choose a location")
                .scalableFont(size: 17, weight: .semibold)
                .foregroundColor(.primary)

            VStack(spacing: 0) {
                ForEach(Array(locations.enumerated()), id: \.element.id) { idx, loc in
                    locationRow(loc, isLast: idx == locations.count - 1)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            )
        }
    }

    private func locationRow(_ loc: HospitalLocation, isLast: Bool) -> some View {
        let isSelected = selectedLocationID == loc.id
        return Button(action: {
            withAnimation(.spring(response: 0.22)) {
                selectedLocationID = isSelected ? nil : loc.id
            }
        }) {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(loc.bgColor)
                            .frame(width: 46, height: 46)
                        Image(systemName: loc.icon)
                            .scalableFont(size: 18, weight: .medium)
                            .foregroundColor(loc.iconColor)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(loc.name)
                            .scalableFont(size: 15, weight: .semibold)
                            .foregroundColor(.primary)
                        Text(loc.subtitle)
                            .scalableFont(size: 13, weight: .regular)
                            .foregroundColor(Color(.secondaryLabel))
                        Text(loc.time)
                            .scalableFont(size: 12, weight: .medium)
                            .foregroundColor(isSelected ? .brand : Color(.tertiaryLabel))
                            .padding(.top, 1)
                    }
                    Spacer()

                    // Selection indicator
                    ZStack {
                        Circle()
                            .strokeBorder(isSelected ? Color.brand : Color(.systemGray4), lineWidth: 1.5)
                            .background(Circle().fill(isSelected ? Color.brand : Color.white))
                            .frame(width: 22, height: 22)
                        if isSelected {
                            Image(systemName: "checkmark")
                                .scalableFont(size: 10, weight: .bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    isSelected
                        ? Color.brand.opacity(0.04)
                        : Color.white
                )

                if !isLast {
                    Divider()
                        .padding(.leading, 76)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Popular Destinations
    // ─────────────────────────────────────────────────────────────────────────
    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Popular destinations")
                .scalableFont(size: 17, weight: .semibold)
                .foregroundColor(.primary)

            HStack(spacing: 10) {
                    ForEach(popularTags, id: \.self) { tag in
                        let isActive = locations.first(where: { $0.name == tag }).map { selectedLocationID == $0.id } ?? false
                        Button(action: {
                            withAnimation(.spring(response: 0.22)) {
                                if let loc = locations.first(where: { $0.name == tag }) {
                                    selectedLocationID = isActive ? nil : loc.id
                                }
                            }
                        }) {
                            Text(tag)
                                .scalableFont(size: 13, weight: .semibold)
                                .lineLimit(1)
                                .foregroundColor(isActive ? .white : .primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(isActive ? Color.brand : Color.white)
                                        .shadow(color: isActive ? Color.brand.opacity(0.25) : .black.opacity(0.06), radius: 6, x: 0, y: 3)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Recent Locations
    // ─────────────────────────────────────────────────────────────────────────
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent locations")
                .scalableFont(size: 17, weight: .semibold)
                .foregroundColor(.primary)

            VStack(spacing: 0) {
                ForEach(Array(recentLocations.enumerated()), id: \.element.id) { idx, recent in
                    VStack(spacing: 0) {
                        recentRow(recent)
                        if idx < recentLocations.count - 1 {
                            Divider().padding(.leading, 52)
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            )
        }
    }

    private func recentRow(_ recent: RecentLocation) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.22)) {
                if let loc = locations.first(where: { $0.name == recent.name }) {
                    selectedLocationID = loc.id
                }
            }
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 36, height: 36)
                    Image(systemName: "clock")
                        .scalableFont(size: 14, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(recent.name)
                        .scalableFont(size: 15, weight: .medium)
                        .foregroundColor(.primary)
                    Text(recent.when)
                        .scalableFont(size: 12, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .scalableFont(size: 12, weight: .semibold)
                    .foregroundColor(Color(.systemGray3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }

}

// MARK: - Preview
#Preview {
    DirectionsView()
}
