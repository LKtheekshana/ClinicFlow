import SwiftUI
import Combine

// ─────────────────────────────────────────────────────────────────────────────
// MARK: TabRouter  —  single source of truth for the active bottom tab
// ─────────────────────────────────────────────────────────────────────────────
class TabRouter: ObservableObject {
    @Published var selectedTab: AppBottomTabBar.Tab = .home
}
