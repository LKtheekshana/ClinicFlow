import SwiftUI

extension Color {
    /// CareConnect brand blue  –  PayPal #0066BA
    static let brand = Color(red: 0.00, green: 0.40, blue: 0.73)
}

extension ShapeStyle where Self == Color {
    static var brand: Color { .brand }
}