import SwiftUI

struct SplashScreenView: View {

    @State private var isActive        = false

    // Entrance animations
    @State private var logoScale       = 0.55
    @State private var logoOpacity     = 0.0
    @State private var textOpacity     = 0.0
    @State private var taglineOpacity  = 0.0
    @State private var badgeOffset: CGFloat = 30

    // Pulse ring
    @State private var pulseScale      = 1.0
    @State private var pulseOpacity    = 0.55

    // Progress bar
    @State private var progressWidth: CGFloat = 0

    // Orb float
    @State private var orbOffset1: CGFloat = 0
    @State private var orbOffset2: CGFloat = 0

    private let accentBlue   = Color(red: 0.22, green: 0.44, blue: 0.92)
    private let deepBlue     = Color(red: 0.10, green: 0.18, blue: 0.48)
    private let softBlue     = Color(red: 0.36, green: 0.58, blue: 0.98)

    var body: some View {
        if isActive {
            OnboardingView()
        } else {
            GeometryReader { geo in
                ZStack {

                    // ── Background gradient ───────────────────────────────────
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.15, blue: 0.42),
                            Color(red: 0.16, green: 0.32, blue: 0.76),
                            Color(red: 0.22, green: 0.44, blue: 0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    // ── Decorative orbs ───────────────────────────────────────
                    Circle()
                        .fill(softBlue.opacity(0.18))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -geo.size.width * 0.35,
                                y: -geo.size.height * 0.28 + orbOffset1)

                    Circle()
                        .fill(accentBlue.opacity(0.22))
                        .frame(width: 260, height: 260)
                        .blur(radius: 55)
                        .offset(x: geo.size.width * 0.38,
                                y: geo.size.height * 0.30 + orbOffset2)

                    Circle()
                        .fill(deepBlue.opacity(0.30))
                        .frame(width: 180, height: 180)
                        .blur(radius: 40)
                        .offset(x: geo.size.width * 0.20,
                                y: -geo.size.height * 0.10 + orbOffset1 * 0.6)

                    // ── Centre content ────────────────────────────────────────
                    VStack(spacing: 0) {

                        Spacer()

                        // Pulse ring + logo icon
                        ZStack {
                            // outer pulse ring
                            Circle()
                                .stroke(Color.white.opacity(0.14), lineWidth: 1.5)
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseScale)
                                .opacity(pulseOpacity)

                            // frosted glass card
                            Circle()
                                .fill(.white.opacity(0.12))
                                .frame(width: 96, height: 96)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 8)

                            // icon
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 38, weight: .medium))
                                .foregroundStyle(.white)
                                .shadow(color: accentBlue.opacity(0.6), radius: 10, x: 0, y: 4)
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .offset(y: badgeOffset)

                        // App name
                        Text("CareConnect")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(0.4)
                            .padding(.top, 24)
                            .opacity(textOpacity)

                        // Tagline
                        Text("Your Health, Our Priority")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.65))
                            .padding(.top, 8)
                            .opacity(taglineOpacity)

                        Spacer()

                        // ── Progress bar ──────────────────────────────────
                        VStack(spacing: 10) {
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.white.opacity(0.15))
                                    .frame(width: 140, height: 3)
                                Capsule()
                                    .fill(.white.opacity(0.85))
                                    .frame(width: progressWidth, height: 3)
                            }

                            Text("Loading…")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.45))
                                .tracking(1.2)
                        }
                        .padding(.bottom, geo.safeAreaInsets.bottom + 44)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear { runAnimations() }
        }
    }

    // MARK: – Animations
    private func runAnimations() {

        // Floating orbs
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            orbOffset1 = -18
        }
        withAnimation(.easeInOut(duration: 5.2).repeatForever(autoreverses: true)) {
            orbOffset2 = 22
        }

        // Logo entrance
        withAnimation(.spring(response: 0.65, dampingFraction: 0.70).delay(0.15)) {
            logoScale   = 1.0
            logoOpacity = 1.0
            badgeOffset = 0
        }

        // Pulse ring
        withAnimation(.easeOut(duration: 1.8).repeatForever(autoreverses: false).delay(0.4)) {
            pulseScale   = 1.55
            pulseOpacity = 0.0
        }

        // Text
        withAnimation(.easeOut(duration: 0.55).delay(0.50)) {
            textOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.55).delay(0.72)) {
            taglineOpacity = 1.0
        }

        // Progress bar fills over 2.6 s
        withAnimation(.easeInOut(duration: 2.6).delay(0.3)) {
            progressWidth = 140
        }

        // Navigate
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation(.easeInOut(duration: 0.45)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}