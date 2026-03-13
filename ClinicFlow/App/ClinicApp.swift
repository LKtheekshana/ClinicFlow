
import SwiftUI

@main
struct CareConnectApp: App {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @StateObject private var profileStore = UserProfileStore()
    @StateObject private var appSettings = AppSettings()
    @StateObject private var voiceGuidance = VoiceGuidanceManager()

    var body: some Scene {
        WindowGroup {
            if isOnboardingComplete {
                MainTabView()
                    .environmentObject(profileStore)
                    .environmentObject(appSettings)
                    .environmentObject(voiceGuidance)
                    .preferredColorScheme(appSettings.colorScheme)
                    .environment(\.sizeCategory, appSettings.sizeCategory)
            } else {
                NavigationStack {
                    SplashScreenView()
                }
                .environmentObject(profileStore)
                .environmentObject(appSettings)
                .environmentObject(voiceGuidance)
                .preferredColorScheme(appSettings.colorScheme)
                .environment(\.sizeCategory, appSettings.sizeCategory)
            }
        }
    }
}

