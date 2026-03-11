import SwiftUI

// ─────────────────────────────────────────────────────────────────────────────
// MARK: MainTabView  —  root container with a truly fixed bottom tab bar.
//
//  Each tab lives in its own NavigationStack so deep navigation state is
//  preserved per tab (same as UITabBarController behaviour).
//  The tab bar is attached via `.safeAreaInset` on EACH NavigationStack so
//  that every pushed sub-screen inside a stack automatically receives the
//  correct bottom safe area — the bar is always visible, never animated.
// ─────────────────────────────────────────────────────────────────────────────
struct MainTabView: View {

    @StateObject private var tabRouter = TabRouter()

    // Build one tab bar instance — all 4 stacks share the same active state
    // because they all read from the same tabRouter.
    private func tabBar() -> some View {
        AppBottomTabBar(
            activeTab: tabRouter.selectedTab,
            onHome:     { withAnimation(.none) { tabRouter.selectedTab = .home } },
            onMessages: { withAnimation(.none) { tabRouter.selectedTab = .messages } },
            onBookings: { withAnimation(.none) { tabRouter.selectedTab = .bookings } },
            onSettings: { withAnimation(.none) { tabRouter.selectedTab = .settings } }
        )
    }

    var body: some View {
        ZStack {
            // ── Home tab ──────────────────────────────────────────────────
            NavigationStack {
                HomeDashboardView()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { tabBar() }
            .opacity(tabRouter.selectedTab == .home ? 1 : 0)
            .allowsHitTesting(tabRouter.selectedTab == .home)

            // ── Messages tab ──────────────────────────────────────────────
            NavigationStack {
                NotificationsView()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { tabBar() }
            .opacity(tabRouter.selectedTab == .messages ? 1 : 0)
            .allowsHitTesting(tabRouter.selectedTab == .messages)

            // ── Bookings tab ──────────────────────────────────────────────
            NavigationStack {
                BookingsView()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { tabBar() }
            .opacity(tabRouter.selectedTab == .bookings ? 1 : 0)
            .allowsHitTesting(tabRouter.selectedTab == .bookings)

            // ── Settings tab ──────────────────────────────────────────────
            NavigationStack {
                SettingsView()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { tabBar() }
            .opacity(tabRouter.selectedTab == .settings ? 1 : 0)
            .allowsHitTesting(tabRouter.selectedTab == .settings)
        }
        .environmentObject(tabRouter)
    }
}
