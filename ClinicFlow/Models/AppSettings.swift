import SwiftUI
import Combine

/// Custom environment key for font size multiplier
struct FontSizeMultiplierKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    var fontSizeMultiplier: CGFloat {
        get { self[FontSizeMultiplierKey.self] }
        set { self[FontSizeMultiplierKey.self] = newValue }
    }
}

/// Observable app settings that syncs with AppStorage
final class AppSettings: ObservableObject {
    @Published var appTheme: String {
        didSet {
            UserDefaults.standard.set(appTheme, forKey: "appTheme")
        }
    }
    
    @Published var appTextSize: String {
        didSet {
            UserDefaults.standard.set(appTextSize, forKey: "appTextSize")
            updateSizeCategory()
        }
    }
    
    @Published var sizeCategory: ContentSizeCategory = .medium
    @Published var fontSizeMultiplier: CGFloat = 1.0
    
    init() {
        self.appTheme = UserDefaults.standard.string(forKey: "appTheme") ?? "System"
        self.appTextSize = UserDefaults.standard.string(forKey: "appTextSize") ?? "Default"
        self.updateSizeCategory()
    }
    
    var colorScheme: ColorScheme? {
        switch appTheme {
        case "Light": return .light
        case "Dark":  return .dark
        default:      return nil
        }
    }
    
    private func updateSizeCategory() {
        switch appTextSize {
        case "Small":
            sizeCategory = .small
            fontSizeMultiplier = 0.9
        case "Large":
            sizeCategory = .large
            fontSizeMultiplier = 1.1
        case "Extra Large":
            sizeCategory = .extraLarge
            fontSizeMultiplier = 1.25
        default:
            sizeCategory = .medium
            fontSizeMultiplier = 1.0
        }
    }
}
