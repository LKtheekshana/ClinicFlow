import SwiftUI
import Combine

/// Single source of truth for the logged-in user's profile.
/// Shared between UserProfileView, AllProfilesView, and PatientDetailsView.
final class UserProfileStore: ObservableObject {

    // Personal info (UserProfileView)
    @Published var firstName:   String = "Dineth"
    @Published var lastName:    String = "Chandima"
    @Published var username:    String = "thisisuname"
    @Published var email:       String = "dineth@example.com"
    @Published var phone:       String = "+94 77 123 4567"
    @Published var dateOfBirth: String = "Jan 15, 1998"
    @Published var gender:      String = "Male"
    @Published var bloodType:   String = "O+"
    @Published var city:        String = "Colombo"
    @Published var country:     String = "Sri Lanka"

    // Patient details (PatientDetailsView)
    @Published var patientFullName: String = ""
    @Published var patientGender:   String = ""
    @Published var age:             String = ""
    @Published var nickName:        String = ""
    @Published var guardianName:    String = ""
    @Published var allergies:       String = ""

    // Family profiles (AllProfilesView / PatientDetailsView)
    @Published var familyProfiles: [FamilyProfile] = [
        FamilyProfile(
            firstName: "Dineth", lastName: "Chandima",
            relation: "Self", gender: "Male",
            bloodType: "O+", phone: "+94 77 123 4567",
            color: Color(red: 0.26, green: 0.52, blue: 0.96)
        )
    ]

    /// Derived full name from profile first/last name.
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var initials: String {
        "\(firstName.prefix(1).uppercased())\(lastName.prefix(1).uppercased())"
    }
}
