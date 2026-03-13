import SwiftUI

struct ProfileNavBar: View {
    @EnvironmentObject private var profileStore: UserProfileStore
    @EnvironmentObject private var tabRouter: TabRouter
    @State private var showNotifications = false
    @State private var navigateToProfiles = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Section - Navigates to AllProfilesView
            NavigationLink(destination: AllProfilesView()) {
                HStack(spacing: 12) {
                    // Profile Avatar Image
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.brand.opacity(0.6),
                                        Color.brand.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Image(systemName: "person.fill")
                            .scalableFont(size: 16, weight: .semibold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 48, height: 48)
                    
                    // User Name
                    Text(profileStore.firstName)
                        .scalableFont(size: 28, weight: .bold)
                        .foregroundColor(Color(red: 0.08, green: 0.09, blue: 0.18))
                        .tracking(-0.5)
                }
            }
            
            Spacer()
            
            // Notification Bell
            Button(action: { tabRouter.selectedTab = .messages }) {
                Image(systemName: "bell")
                    .scalableFont(size: 18, weight: .semibold)
                    .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))
                    .frame(width: 44, height: 44)
                    .contentShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        ProfileNavBar()
            .environmentObject(UserProfileStore())
            .environmentObject(TabRouter())
    }
}
