import SwiftUI

@main
struct AppIconGenerator {
    static func main() {
        let sizes: [(name: String, points: CGFloat)] = [
            ("app-icon-20@2x", 40),
            ("app-icon-20@3x", 60),
            ("app-icon-29@2x", 58),
            ("app-icon-29@3x", 87),
            ("app-icon-40@2x", 80),
            ("app-icon-40@3x", 120),
            ("app-icon-60@2x", 120),
            ("app-icon-60@3x", 180),
            ("app-icon-76", 76),
            ("app-icon-76@2x", 152),
            ("app-icon-83.5@2x", 167),
            ("app-icon-1024", 1024),
        ]
        
        let outputPath = "/Users/cobsccomp242p-031/Theekshana/ClinicFlow/IOS-Clinic-App/ClinicApp/Resources/Assets.xcassets/AppIcon.appiconset/"
        
        for (filename, size) in sizes {
            let icon = AppIconView(size: size)
            
            if let image = renderViewToImage(icon, size: CGSize(width: size, height: size)) {
                let url = URL(fileURLWithPath: outputPath + filename + ".png")
                if let pngData = image.pngData() {
                    try? pngData.write(to: url)
                    print("✓ Generated \(filename).png")
                }
            }
        }
        
        print("✓ All app icons generated successfully!")
    }
    
    static func renderViewToImage<V: View>(_ view: V, size: CGSize) -> NSImage? {
        let hostingView = NSHostingController(rootView: view)
        hostingView.view.frame = NSRect(origin: .zero, size: size)
        
        guard let bitmapImage = hostingView.view.bitmapImageRepForCachingDisplay(in: hostingView.view.bounds) else {
            return nil
        }
        
        hostingView.view.cacheDisplay(in: hostingView.view.bounds, to: bitmapImage)
        
        let image = NSImage(size: size)
        image.addRepresentation(bitmapImage)
        return image
    }
}

struct AppIconView: View {
    let size: CGFloat
    
    private let accentBlue = Color(red: 0.22, green: 0.44, blue: 0.92)
    private let deepBlue = Color(red: 0.10, green: 0.18, blue: 0.48)
    private let softBlue = Color(red: 0.36, green: 0.58, blue: 0.98)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.15, blue: 0.42),
                    Color(red: 0.16, green: 0.32, blue: 0.76),
                    Color(red: 0.22, green: 0.44, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Main circle with icon
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [accentBlue, deepBlue]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size * 0.75, height: size * 0.75)
            
            // Person icon
            Image(systemName: "figure.stand")
                .font(.system(size: size * 0.35, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: size, height: size)
    }
}
