import SwiftUI

// MARK: - Model
struct AppNotification: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    let time: String
    var isUnread: Bool
}

// MARK: - View
struct NotificationsView: View {
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var voiceGuidance: VoiceGuidanceManager

    @State private var notifications: [AppNotification] = [
        AppNotification(
            icon: "calendar.badge.clock",
            iconColor: Color(red: 0.26, green: 0.48, blue: 0.96),
            iconBackground: Color(red: 0.26, green: 0.48, blue: 0.96).opacity(0.12),
            title: "Reminder for your booking",
            subtitle: "Your doctor has arrived",
            time: "9 min ago",
            isUnread: true
        ),
        AppNotification(
            icon: "flask.fill",
            iconColor: Color(red: 0.14, green: 0.66, blue: 0.38),
            iconBackground: Color(red: 0.14, green: 0.66, blue: 0.38).opacity(0.12),
            title: "Lab report is ready",
            subtitle: "Go collect your lab report",
            time: "14 min ago",
            isUnread: true
        ),
        AppNotification(
            icon: "exclamationmark.circle.fill",
            iconColor: Color(red: 0.90, green: 0.28, blue: 0.26),
            iconBackground: Color(red: 0.90, green: 0.28, blue: 0.26).opacity(0.10),
            title: "Appointment Cancelled",
            subtitle: "Doctor has cancelled today's appointment.",
            time: "2 hrs ago",
            isUnread: false
        ),
        AppNotification(
            icon: "pills.fill",
            iconColor: Color(red: 0.82, green: 0.60, blue: 0.10),
            iconBackground: Color(red: 0.82, green: 0.60, blue: 0.10).opacity(0.12),
            title: "Pharmacy",
            subtitle: "Your prescription order is being prepared.",
            time: "Yesterday",
            isUnread: false
        ),
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    // ── Scrollable content ────────────────────────────────
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            // Today section
                            sectionLabel("Today")
                                .padding(.horizontal, 20)
                                .padding(.bottom, 12)

                            VStack(spacing: 10) {
                                ForEach(Array(notifications.enumerated()), id: \.element.id) { idx, item in
                                    notificationCell(item: item, index: idx)
                                        .padding(.horizontal, 20)
                                }
                            }

                            Spacer(minLength: 100 + geo.safeAreaInsets.bottom)
                        }
                    }


                }
            }
        }
        .clinicNavBar(title: "Notifications", onBack: { tabRouter.selectedTab = .home }) {
            ToolbarCircleButton(icon: "ellipsis", action: {})
        }
        .onAppear {
            voiceGuidance.announceScreen(title: "Notifications", instructions: "You have \(notifications.count) notifications. Swipe through to read each notification.")
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Header
    // ─────────────────────────────────────────────────────────────────────────
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .scalableFont(size: 13, weight: .semibold)
            .foregroundColor(Color(.secondaryLabel))
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Notification cell
    // ─────────────────────────────────────────────────────────────────────────
    private func notificationCell(item: AppNotification, index: Int) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(item.iconBackground)
                    .frame(width: 48, height: 48)
                Image(systemName: item.icon)
                    .scalableFont(size: 20, weight: .medium)
                    .foregroundColor(item.iconColor)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .scalableFont(size: 13)
                        .foregroundColor(Color(.secondaryLabel))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Time + unread dot
            VStack(alignment: .trailing, spacing: 6) {
                if !item.time.isEmpty {
                    Text(item.time)
                        .scalableFont(size: 11, weight: .regular)
                        .foregroundColor(Color(.tertiaryLabel))
                        .fixedSize()
                }
                if item.isUnread {
                    Circle()
                        .fill(Color.brand)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(item.isUnread ? Color.white : Color.white.opacity(0.72))
                .shadow(color: .black.opacity(item.isUnread ? 0.07 : 0.04),
                        radius: item.isUnread ? 10 : 6, x: 0, y: item.isUnread ? 4 : 2)
        )
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                notifications[index].isUnread = false
            }
        }
    }

}

// MARK: - Preview
#Preview {
    NotificationsView()
}
