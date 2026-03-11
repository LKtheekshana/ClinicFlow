import SwiftUI

// ─────────────────────────────────────────────────────────────────────────────
// MARK: AppBottomTabBar  —  shared bottom navigation bar used across all screens
// ─────────────────────────────────────────────────────────────────────────────
//  Usage – active tab with dismiss on Home:
//      AppBottomTabBar(activeTab: .home, onHome: { dismiss() })
//
//  Usage – with full navigation (HomeDashboard):
//      AppBottomTabBar(
//          activeTab: .home,
//          onMessages: { navigateToNotifications = true },
//          onBookings: { navigateToBookings = true },
//          onSettings: { navigateToSettings = true }
//      )
// ─────────────────────────────────────────────────────────────────────────────

struct AppBottomTabBar: View {

    enum Tab { case home, messages, bookings, settings }

    var activeTab: Tab   = .home
    var onHome:     () -> Void = {}
    var onMessages: () -> Void = {}
    var onBookings: () -> Void = {}
    var onSettings: () -> Void = {}

    private struct TabDef {
        let icon: String
        let title: String
        let tab: Tab
    }

    private let tabs: [TabDef] = [
        TabDef(icon: "house.fill",     title: "Home",     tab: .home),
        TabDef(icon: "message.fill",   title: "Messages", tab: .messages),
        TabDef(icon: "calendar",       title: "Bookings", tab: .bookings),
        TabDef(icon: "gearshape.fill", title: "Settings", tab: .settings),
    ]

    var body: some View {
        HStack {
            ForEach(tabs.indices, id: \.self) { i in
                let item = tabs[i]
                Spacer(minLength: 0)
                Button(action: { withAnimation(.none) { action(for: item.tab)() } }) {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: .semibold))
                        Text(item.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(
                        item.tab == activeTab
                            ? Color.brand
                            : Color(red: 0.62, green: 0.65, blue: 0.72)
                    )
                }
                .buttonStyle(.plain)
                Spacer(minLength: 0)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            Color.white
                .overlay(Divider(), alignment: .top)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func action(for tab: Tab) -> () -> Void {
        switch tab {
        case .home:     return onHome
        case .messages: return onMessages
        case .bookings: return onBookings
        case .settings: return onSettings
        }
    }
}