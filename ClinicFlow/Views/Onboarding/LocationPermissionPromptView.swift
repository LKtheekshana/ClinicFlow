import SwiftUI

struct LocationPermissionPromptView: View {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Allow \"MapFlow\" to use your\nlocation?")
                        .font(.system(size: 40 / 2, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.20))
                        .padding(.top, 44)

                    Text("Your precise location is used to show your\nposition on the map, get directions, estimate\ntravel times and improve search results.")
                        .font(.system(size: 17 * 0.95, weight: .regular))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .foregroundColor(Color(red: 0.30, green: 0.33, blue: 0.39))
                        .padding(.top, 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.91, green: 0.96, blue: 0.94),
                                        Color(red: 0.78, green: 0.84, blue: 0.92)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.08), lineWidth: 1)

                        VStack {
                            HStack {
                                Capsule()
                                    .fill(Color.white.opacity(0.85))
                                    .frame(width: 100, height: 36)
                                    .overlay {
                                        HStack(spacing: 4) {
                                            Text("Precise:")
                                                .foregroundColor(Color(red: 0.30, green: 0.33, blue: 0.39))
                                            Text("On")
                                                .foregroundColor(.brand)
                                        }
                                        .font(.system(size: 15, weight: .medium))
                                    }

                                Spacer()
                            }
                            .padding(.top, 14)
                            .padding(.leading, 14)

                            Spacer()

                            Circle()
                                .fill(Color.brand)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)

                            Spacer()

                            HStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.25))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(1)

                                Rectangle()
                                    .fill(Color.gray.opacity(0.20))
                                    .frame(width: 34, height: 2)

                                Spacer()
                            }
                            .padding(.leading, 220)
                            .padding(.bottom, 14)
                        }

                        Rectangle()
                            .fill(Color.gray.opacity(0.20))
                            .frame(width: 40, height: 14)
                            .padding(.leading, -220)
                            .padding(.top, -92)
                    }
                    .frame(height: 150)
                    .padding(.top, 22)
                    .padding(.horizontal, 26)

                    Divider()
                        .padding(.top, 26)

                    PermissionActionRow(title: "Allow Once") {
                        isOnboardingComplete = true
                    }
                    PermissionActionRow(title: "Allow While Using App") {
                        isOnboardingComplete = true
                    }
                    PermissionActionRow(title: "Don't Allow", showsDivider: false) {
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
            .frame(maxWidth: 390)
            .padding(.horizontal, 34)
            .shadow(color: Color.black.opacity(0.25), radius: 28, x: 0, y: 18)
        }
    }
}

private struct PermissionActionRow: View {
    let title: String
    var showsDivider: Bool = true
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button {
                action()
            } label: {
                Text(title)
                    .font(.system(size: 36 / 2, weight: .regular))
                    .foregroundColor(.brand)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
            }

            if showsDivider {
                Divider()
            }
        }
    }
}

#Preview {
    LocationPermissionPromptView()
}