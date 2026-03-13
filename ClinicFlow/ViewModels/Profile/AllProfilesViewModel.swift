import SwiftUI
import Combine

final class AllProfilesViewModel: ObservableObject {

    // MARK: - Profiles
    @Published var profiles: [FamilyProfile] = [
        FamilyProfile(
            firstName: "Dineth", lastName: "Chandima",
            relation: "Self", gender: "Male",
            bloodType: "O+", phone: "+94 77 123 4567",
            color: Color(red: 0.26, green: 0.52, blue: 0.96)
        )
    ]

    // MARK: - Sheet / Navigation State
    @Published var showAddSheet   = false
    @Published var navigateToEdit = false
    @Published var selectedProfile: FamilyProfile?

    // MARK: - Avatar Colors
    let avatarColors: [Color] = [
        Color(red: 0.26, green: 0.52, blue: 0.96),
        Color(red: 0.14, green: 0.66, blue: 0.38),
        Color(red: 0.82, green: 0.30, blue: 0.22),
        Color(red: 0.58, green: 0.28, blue: 0.86),
        Color(red: 0.90, green: 0.55, blue: 0.10),
        Color(red: 0.18, green: 0.60, blue: 0.60),
    ]

    var nextAvatarColor: Color {
        avatarColors[profiles.count % avatarColors.count]
    }

    var profileCountLabel: String {
        "\(profiles.count) profile\(profiles.count == 1 ? "" : "s")"
    }

    // MARK: - CRUD
    func addProfile(_ profile: FamilyProfile) {
        profiles.append(profile)
    }

    func deleteProfile(at offsets: IndexSet) {
        profiles.remove(atOffsets: offsets)
    }

    func select(_ profile: FamilyProfile) {
        selectedProfile = profile
        navigateToEdit  = true
    }
}
