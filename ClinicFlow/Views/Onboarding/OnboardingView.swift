import SwiftUI

struct OnboardingView: View {
    
    @State private var navigateToHome = false
    
    var body: some View {
        ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    Spacer()

                    // MARK: - Top Illustration Area
                    Image("onboarding_image")
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height * 0.42)
                        .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 32)

                    // MARK: - Text Content
                    VStack(spacing: 12) {
                        Text("Start Together")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("We will guide you to where\nyou wanted it to")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.bottom, 30)
                    
                    // MARK: - Get Started Button
                    Button(action: {
                        navigateToHome = true
                    }) {
                        Text("Get Started")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.brand)
                            .cornerRadius(16)
                            .shadow(color: Color.brand.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    // Navigation trigger
                   .navigationDestination(isPresented: $navigateToHome) {
    TermsOfServiceView()
        .toolbar(.hidden, for: .navigationBar)
}
                }
            }
            .toolbar(.hidden, for: .navigationBar)
    }
}