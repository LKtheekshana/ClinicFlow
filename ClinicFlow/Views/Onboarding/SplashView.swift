import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void = {}

    @State private var animateDots = false

    private let backgroundColor = Color(red: 0.48, green: 0.62, blue: 0.96)
    private let centerDotColor = Color(red: 0.27, green: 0.49, blue: 0.94)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 28) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 52, height: 52)

                        Circle()
                            .fill(centerDotColor)
                            .frame(width: 16, height: 16)

                        Image(systemName: "figure.stand")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Text("CareConnect")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(y: -12)

                LoadingDotsView(isAnimating: animateDots)
            }
        }
        .onAppear {
            animateDots = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}

private struct LoadingDotsView: View {
    let isAnimating: Bool

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .opacity(0.6)
                    .scaleEffect(isAnimating ? 1.0 : 0.7)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.15),
                        value: isAnimating
                    )
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .preferredColorScheme(.light)
    }
}