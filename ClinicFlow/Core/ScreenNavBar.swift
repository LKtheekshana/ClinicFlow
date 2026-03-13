import SwiftUI

// ─────────────────────────────────────────────────────────────────────────────
// MARK: ScreenNavBar  —  shared navigation bar used across all screens
// ─────────────────────────────────────────────────────────────────────────────
//  Usage – back button only:
//      ScreenNavBar(title: "Bookings", onBack: { dismiss() })
//
//  Usage – with trailing icon:
//      ScreenNavBar(title: "Tests", onBack: { dismiss() }) {
//          NavCircleButton(icon: "cart", action: {})
//      }
//
//  Usage – with custom trailing view:
//      ScreenNavBar(title: "Profiles", onBack: { dismiss() }) {
//          Text("3 profiles").font(.caption)
//      }
// ─────────────────────────────────────────────────────────────────────────────

struct ScreenNavBar<Trailing: View>: View {

    let title: String
    let onBack: () -> Void
    private let trailingView: Trailing

    // Full init — @ViewBuilder trailing
    init(
        title: String,
        onBack: @escaping () -> Void,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.onBack = onBack
        self.trailingView = trailing()
    }

    var body: some View {
        ZStack {
            if !title.isEmpty {
                Text(title)
                    .scalableFont(size: 18, weight: .semibold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                NavCircleButton(icon: "arrow.left", action: onBack)
                Spacer()
                trailingView
            }
        }
    }
}

// Convenience: back-only nav bar (no trailing)
extension ScreenNavBar where Trailing == NavBarPlaceholder {
    init(title: String, onBack: @escaping () -> Void) {
        self.init(title: title, onBack: onBack, trailing: { NavBarPlaceholder() })
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: NavCircleButton  —  standard 36 × 36 circle icon button
// ─────────────────────────────────────────────────────────────────────────────
struct NavCircleButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .semibold)
                .foregroundColor(.primary)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: NavBarPlaceholder  —  invisible spacer to balance left back button
// ─────────────────────────────────────────────────────────────────────────────
struct NavBarPlaceholder: View {
    var body: some View {
        Color.clear.frame(width: 36, height: 36)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: ToolbarCircleButton  —  circle icon button styled for the system toolbar
//       (no extra background since the toolbar provides its own chrome)
// ─────────────────────────────────────────────────────────────────────────────
struct ToolbarCircleButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .scalableFont(size: 15, weight: .semibold)
                .foregroundColor(.primary)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color(.systemGray6))
                )
        }
        .buttonStyle(.plain)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: clinicNavBar — routes nav bar into the system UINavigationBar so it
//       stays fixed (crossfades) during push/pop transitions instead of sliding
//       with the page content.
// ─────────────────────────────────────────────────────────────────────────────
extension View {
    /// Back-button only variant.
    func clinicNavBar(title: String, onBack: @escaping () -> Void) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ToolbarCircleButton(icon: "arrow.left", action: onBack)
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .scalableFont(size: 18, weight: .semibold)
                        .foregroundColor(.primary)
                }
            }
    }

    /// Back-button + custom trailing view variant.
    func clinicNavBar<T: View>(
        title: String,
        onBack: @escaping () -> Void,
        @ViewBuilder trailing: () -> T
    ) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ToolbarCircleButton(icon: "arrow.left", action: onBack)
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .scalableFont(size: 18, weight: .semibold)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailing()
                }
            }
    }

    // ── Tab-root variants (no back button) ───────────────────────────────────

    /// Title only, no back button — for tab root screens.
    func clinicNavBar(title: String) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .scalableFont(size: 18, weight: .semibold)
                        .foregroundColor(.primary)
                }
            }
    }

    /// Title + trailing view, no back button — for tab root screens.
    func clinicNavBar<T: View>(
        title: String,
        @ViewBuilder trailing: () -> T
    ) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .scalableFont(size: 18, weight: .semibold)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailing()
                }
            }
    }
}
