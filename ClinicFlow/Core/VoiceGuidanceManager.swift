import AVFoundation
import Combine
import SwiftUI

/// Manages voice guidance functionality for accessibility
final class VoiceGuidanceManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isEnabled = false
    @Published var isLoading = false
    
    private let synthesizer = AVSpeechSynthesizer()
    private var isSpeaking = false
    
    override init() {
        super.init()
        self.synthesizer.delegate = self
        
        // Configure audio session for speech synthesis
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
        
        // Load saved preference
        self.isEnabled = UserDefaults.standard.bool(forKey: "voiceGuidanceEnabled")
    }
    
    /// Speak the given text with voice guidance
    func speak(_ text: String) {
        guard isEnabled else { return }
        guard !text.isEmpty else { return }
        
        // Stop any ongoing speech
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        // Try to use English voice, fall back to default if not available
        if let englishVoice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = englishVoice
        } else if let englishVoice = AVSpeechSynthesisVoice(language: "en") {
            utterance.voice = englishVoice
        }
        
        isSpeaking = true
        DispatchQueue.main.async {
            self.synthesizer.speak(utterance)
        }
    }
    
    /// Announce page title and instructions
    func announceScreen(title: String, instructions: String = "") {
        let fullMessage = instructions.isEmpty ? title : "\(title). \(instructions)"
        speak(fullMessage)
    }
    
    /// Announce button and its purpose
    func announceButton(_ buttonName: String, purpose: String) {
        speak("\(buttonName) button. \(purpose)")
    }
    
    /// Announce selected item
    func announceSelection(_ item: String) {
        speak("Selected \(item)")
    }
    
    /// Announce successful action
    func announceSuccess(_ message: String) {
        speak("\(message). Success.")
    }
    
    /// Announce error
    func announceError(_ error: String) {
        speak("Error: \(error)")
    }
    
    /// Stop any ongoing speech
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    /// Toggle voice guidance on/off
    func toggle() {
        isEnabled.toggle()
        UserDefaults.standard.set(isEnabled, forKey: "voiceGuidanceEnabled")
        if isEnabled {
            speak("Voice guidance enabled")
        }
    }
    
    /// Set voice guidance to a specific state
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "voiceGuidanceEnabled")
        if enabled {
            speak("Voice guidance enabled")
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isLoading = true
        isSpeaking = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isLoading = false
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isLoading = false
        isSpeaking = false
    }
}

// MARK: - Convenience Extension

extension View {
    /// Get access to voice guidance manager for speaking text
    func withVoiceGuidance(_ voiceGuidanceManager: VoiceGuidanceManager) -> some View {
        self.environmentObject(voiceGuidanceManager)
    }
}
