import SwiftUI

struct AccessibilitySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appSettings: AppSettings
    @EnvironmentObject private var voiceGuidance: VoiceGuidanceManager

    private let textSizes = ["Small", "Default", "Large", "Extra Large"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {

                // ── Voice Guidance ──────────────────────────────────────────
                sectionCard(title: "Voice Guidance", icon: "speaker.wave.2.fill", iconColor: Color(red: 0.90, green: 0.26, blue: 0.22)) {
                    VStack(spacing: 0) {
                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Enable Voice Guidance")
                                    .scalableFont(size: 15, weight: .semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Get audio announcements for screen elements")
                                    .scalableFont(size: 13)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $voiceGuidance.isEnabled)
                                .labelsHidden()
                                .tint(.brand)
                                .onChange(of: voiceGuidance.isEnabled) { oldValue, newValue in
                                    // Save the preference to UserDefaults
                                    UserDefaults.standard.set(newValue, forKey: "voiceGuidanceEnabled")
                                    if newValue {
                                        voiceGuidance.speak("Voice guidance enabled")
                                    }
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                }

                // ── Text Size ──────────────────────────────────────────────
                sectionCard(title: "Text Size", icon: "textformat.size", iconColor: Color(red: 0.14, green: 0.66, blue: 0.38)) {
                    VStack(spacing: 0) {
                        ForEach(textSizes, id: \.self) { size in
                            Button {
                                appSettings.appTextSize = size
                            } label: {
                                HStack {
                                    Text(textSizeLabel(size))
                                        .scalableFont(size: fontSize(for: size), weight: .medium)
                                        .foregroundColor(.primary)
                                        .frame(width: 32, alignment: .leading)

                                    Text(size)
                                        .scalableFont(size: 15, weight: .medium)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    if appSettings.appTextSize == size {
                                        Image(systemName: "checkmark.circle.fill")
                                            .scalableFont(size: 20)
                                            .foregroundColor(Color.brand)
                                    } else {
                                        Circle()
                                            .strokeBorder(Color(.systemGray4), lineWidth: 1.5)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)

                            if size != textSizes.last {
                                Divider().padding(.leading, 64)
                            }
                        }
                    }
                }

            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Accessibility", onBack: { dismiss() })
        .environmentObject(voiceGuidance)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Helpers
    // ─────────────────────────────────────────────────────────────────────────
    private func fontSize(for size: String) -> CGFloat {
        switch size {
        case "Small":       return 11
        case "Large":       return 17
        case "Extra Large": return 20
        default:             return 14
        }
    }

    private func textSizeLabel(_ size: String) -> String {
        switch size {
        case "Small":       return "A"
        case "Large":       return "A"
        case "Extra Large": return "A"
        default:             return "A"
        }
    }

    @ViewBuilder
    private func sectionCard<Content: View>(
        title: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .scalableFont(size: 15, weight: .medium)
                        .foregroundColor(iconColor)
                }
                Text(title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)

            Divider()

            content()
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

}

#Preview {
    NavigationStack {
        AccessibilitySettingsView()
            .environmentObject(AppSettings())
    }
}
