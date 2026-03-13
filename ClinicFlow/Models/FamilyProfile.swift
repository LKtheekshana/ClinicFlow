import SwiftUI

// MARK: - Family Profile Model
struct FamilyProfile: Identifiable {
    let id = UUID()
    var firstName:    String
    var lastName:     String
    var relation:     String
    var gender:       String
    var bloodType:    String
    var phone:        String
    var color:        Color
    // Patient-detail fields
    var age:          String = ""
    var nickName:     String = ""
    var guardianName: String = ""
    var allergies:    String = ""

    var initials: String {
        let f = firstName.prefix(1).uppercased()
        let l = lastName.prefix(1).uppercased()
        return "\(f)\(l)"
    }
}
