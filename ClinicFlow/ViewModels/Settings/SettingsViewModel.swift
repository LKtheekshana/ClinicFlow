import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {

    // MARK: - Toggle States
    @Published var faceIDEnabled        = false
    @Published var notificationsEnabled = true
    @Published var darkModeEnabled      = false
    @Published var locationEnabled      = true

    // MARK: - Navigation
    @Published var navigateToProfiles       = false
    @Published var navigateToNotifications  = false
    @Published var navigateToPaymentHistory = false

    // MARK: - Actions
    func openProfiles()       { navigateToProfiles       = true }
    func openNotifications()  { navigateToNotifications  = true }
    func openPaymentHistory() { navigateToPaymentHistory = true }

    func signOut() {
        // TODO: Clear session / auth state
    }
}
