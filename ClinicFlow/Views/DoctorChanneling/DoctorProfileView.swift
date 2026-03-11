import SwiftUI

struct DoctorProfileView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var navigateToPayment = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        topArea(safeTop: geometry.safeAreaInsets.top)

                        profileCard
                            .padding(.horizontal, 20)
                            .padding(.top, -28)
                            .padding(.bottom, max(geometry.safeAreaInsets.bottom + 90, 120))
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToPayment) {
            PaymentMethodView(onDone: onDone)
        }
    }

    private func topArea(safeTop: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 0.92, green: 0.93, blue: 0.95))
                .frame(height: 300)

            NavCircleButton(icon: "arrow.left", action: { dismiss() })
                .padding(.top, max(safeTop + 6, 20))
                .padding(.leading, 20)

            VStack {
                Spacer(minLength: 48)

                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 182, height: 182)
                        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
                        .overlay(
                            Image("doctor_placeholder")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 178, height: 178)
                                .clipShape(Circle())
                        )

                    Circle()
                        .fill(Color(red: 0.13, green: 0.78, blue: 0.36))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 14, height: 14)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                        )
                        .offset(x: 3, y: -2)
                }

                Spacer(minLength: 22)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 300)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dr. Mohan Silva")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.21))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("MBBS, Dermatologist")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color(red: 0.57, green: 0.59, blue: 0.65))
                }

                Spacer(minLength: 10)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(red: 0.98, green: 0.77, blue: 0.10))

                    Text("4.7")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(red: 0.24, green: 0.27, blue: 0.34))
                }
                .padding(.horizontal, 12)
                .frame(height: 34)
                .background(Color(red: 0.98, green: 0.93, blue: 0.73))
                .clipShape(Capsule())
            }

            HStack(spacing: 14) {
                statCard(
                    title: "Patients",
                    value: "5000+",
                    colors: [Color(red: 0.11, green: 0.50, blue: 0.96), Color(red: 0.15, green: 0.39, blue: 0.89)]
                )

                statCard(
                    title: "Experience",
                    value: "08 Years+",
                    colors: [Color(red: 1.00, green: 0.60, blue: 0.00), Color(red: 1.00, green: 0.39, blue: 0.00)]
                )
            }
            .padding(.top, 24)

            Text("About Doctor")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.21))
                .padding(.top, 20)

            Text("Dr. Mohan Silva is a highly experienced dermatologist with over 8 years of practice. He specializes in treating various skin conditions and cosmetic procedures. Dr. Silva is known for his patient-centered approach...")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color(red: 0.57, green: 0.59, blue: 0.65))
                .lineSpacing(5)
                .padding(.top, 10)

            Button("Read More") {
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.brand)
            .padding(.top, 10)

            HStack(spacing: 14) {
                Button {
                } label: {
                    Circle()
                        .fill(Color.brand.opacity(0.14))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Image(systemName: "heart")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.brand)
                        )
                }

                Button {
                    navigateToPayment = true
                } label: {
                    Text("BOOK NOW")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.brand)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.brand.opacity(0.25), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.top, 32)
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 24)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white.opacity(0.96))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.gray.opacity(0.13), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)
    }

    private func statCard(title: String, value: String, colors: [Color]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white.opacity(0.9))

            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(.horizontal, 14)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

}

#Preview {
    DoctorProfileView()
}
