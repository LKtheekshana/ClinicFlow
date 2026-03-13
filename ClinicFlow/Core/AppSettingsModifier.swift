import SwiftUI

extension View {
    func withAppSettings(_ appSettings: AppSettings) -> some View {
        self
            .preferredColorScheme(appSettings.colorScheme)
            .environment(\.sizeCategory, appSettings.sizeCategory)
            .environment(\.fontSizeMultiplier, appSettings.fontSizeMultiplier)
            .environmentObject(appSettings)
    }
}
