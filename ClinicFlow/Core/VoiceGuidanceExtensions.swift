import SwiftUI

// MARK: - Safe Environment Access

/// Custom environment key for voice guidance manager
struct VoiceGuidanceKey: EnvironmentKey {
    static let defaultValue: VoiceGuidanceManager = VoiceGuidanceManager()
}

extension EnvironmentValues {
    var voiceGuidanceManager: VoiceGuidanceManager {
        get { self[VoiceGuidanceKey.self] }
        set { self[VoiceGuidanceKey.self] = newValue }
    }
}

// MARK: - Extensions

/// Extension to easily add voice guidance to buttons and other views
extension View {
    /// Add voice guidance to a button action
    func withVoiceAnnouncement(_ text: String, voiceGuidance: VoiceGuidanceManager) -> some View {
        self.onTapGesture {
            voiceGuidance.speak(text)
        }
    }
    
    /// Ensure voice guidance is always available, even if not provided by parent
    func withVoiceGuidanceFallback() -> some View {
        self.modifier(VoiceGuidanceFallbackModifier())
    }
}

struct VoiceGuidanceFallbackModifier: ViewModifier {
    @Environment(\.voiceGuidanceManager) var voiceGuidance
    
    func body(content: Content) -> some View {
        content
            .environment(\.voiceGuidanceManager, voiceGuidance)
            .environmentObject(voiceGuidance)
    }
}

/// Example implementation guide for adding voice guidance to views:
/*
 
 // Example 1: Add voice guidance to a button
 Button(action: {
     // Your action here
 }) {
     Text("Book Appointment")
 }
 .onTapGesture {
     voiceGuidance.speak("Book appointment button tapped")
 }
 
 // Example 2: Announce page/section title when view appears
 .onAppear {
     voiceGuidance.speak("Booking appointments page")
 }
 
 // Example 3: Announce item selection
 Button {
     selectedDoctor = doctor
     voiceGuidance.speak("Selected Dr. \(doctor.name)")
 } label: {
     Text(doctor.name)
 }
 
 // Example 4: Announce form submission
 Button("Submit") {
     submitForm()
     voiceGuidance.speak("Form submitted successfully")
 }
 
 // Example 5: Announce errors
 .onAppear {
     if hasError {
         voiceGuidance.speak("Error: \(errorMessage)")
     }
 }
 
 // Usage in views:
 @EnvironmentObject var voiceGuidance: VoiceGuidanceManager
 
 var body: some View {
     VStack {
         Text("Your Page Title")
             .onAppear {
                 voiceGuidance.speak("Your page title")
             }
         
         Button("Action Button") {
             // action
         }
         .onTapGesture {
             voiceGuidance.speak("Action button pressed")
         }
     }
     .environmentObject(voiceGuidance)
 }
 
 */
