import SwiftUI

/// Converts ContentSizeCategory to a scaling multiplier
func getSizeMultiplier(_ sizeCategory: ContentSizeCategory) -> CGFloat {
    switch sizeCategory {
    case .extraSmall:       return 0.8
    case .small:            return 0.9
    case .medium:           return 1.0
    case .large:            return 1.1
    case .extraLarge:       return 1.25
    case .extraExtraLarge:  return 1.5
    case .extraExtraExtraLarge: return 1.75
    @unknown default:       return 1.0
    }
}

/// Custom view modifier that scales text based on environment multiplier
struct ScalableTextModifier: ViewModifier {
    @Environment(\.fontSizeMultiplier) var multiplier
    
    let baseSize: CGFloat
    let weight: Font.Weight
    let design: Font.Design
    
    func body(content: Content) -> some View {
        let scaledSize = baseSize * multiplier
        return content.font(.system(size: scaledSize, weight: weight, design: design))
    }
}

extension View {
    /// Apply scalable font that respects accessibility text size settings
    func scalableFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(ScalableTextModifier(baseSize: size, weight: weight, design: design))
    }
}

/// Predefined semantic font sizes with automatic scaling
enum AppFontSize {
    case extraLargeTitle     // ~32pt
    case largeTitle          // ~28pt
    case title               // ~22pt
    case largeBody           // ~18pt
    case body                // ~16pt
    case subheading          // ~15pt
    case smallBody           // ~14pt
    case caption             // ~13pt
    case smallCaption        // ~12pt
    
    var size: CGFloat {
        switch self {
        case .extraLargeTitle:  return 32
        case .largeTitle:       return 28
        case .title:            return 22
        case .largeBody:        return 18
        case .body:             return 16
        case .subheading:       return 15
        case .smallBody:        return 14
        case .caption:          return 13
        case .smallCaption:     return 12
        }
    }
}
