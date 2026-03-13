import SwiftUI

struct QRTokenView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var navigateToConsultation = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        successHeader
                            .padding(.horizontal, 24)
                            .padding(.top, 28)

                        tokenCard
                            .padding(.horizontal, 24)
                            .padding(.top, 30)

                        Text("Please arrive 10–15 minutes before your time slot")
                            .scalableFont(size: 14, weight: .regular)
                            .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))
                            .padding(.horizontal, 24)
                            .padding(.top, 30)

                        Button {
                            navigateToConsultation = true
                        } label: {
                            Text("Continue")
                                .scalableFont(size: 16, weight: .semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.brand)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color.brand.opacity(0.24), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 26)

                        Spacer()
                            .frame(height: 110)
                    }
                }
            }
        }
        .clinicNavBar(title: "Token Generated", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToConsultation) {
            ConsultationView(onDone: onDone)
        }
    }



    private var successHeader: some View {
        VStack(spacing: 18) {
            Circle()
                .fill(Color(red: 0.16, green: 0.72, blue: 0.40))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "checkmark")
                        .scalableFont(size: 30, weight: .bold)
                        .foregroundStyle(.white)
                )
                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 5)

            Text("Token Generated")
                .scalableFont(size: 22, weight: .bold)
                .foregroundStyle(Color(red: 0.08, green: 0.12, blue: 0.20))

            Text("Your queue position has been reserved")
                .scalableFont(size: 14, weight: .regular)
                .foregroundStyle(Color(red: 0.33, green: 0.38, blue: 0.46))
        }
        .frame(maxWidth: .infinity)
    }

    private var tokenCard: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundStyle(.brand)

                    Text("Feb 25, 2026")
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundStyle(Color(red: 0.17, green: 0.19, blue: 0.24))
                }
                .padding(.horizontal, 16)
                .frame(height: 32)
                .background(Color(red: 0.90, green: 0.93, blue: 0.98))
                .clipShape(Capsule())
            }

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(red: 0.86, green: 0.91, blue: 0.98))
                    .frame(width: 150, height: 150)

                Image(systemName: "qrcode")
                    .scalableFont(size: 72)
                    .foregroundStyle(.black)
            }
            .padding(.top, 20)

            Text("Your Token Number")
                .scalableFont(size: 14, weight: .regular)
                .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))
                .padding(.top, 18)

            Text("055")
                .scalableFont(size: 42, weight: .bold)
                .foregroundStyle(.brand)
                .padding(.top, 6)

            Text("General OPD \u{2013} Dr. Mohan Silva")
                .scalableFont(size: 14, weight: .regular)
                .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))
                .padding(.top, 12)

            Divider()
                .padding(.top, 30)

            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .scalableFont(size: 16, weight: .semibold)
                    Text("Est. Wait: 25 min")
                        .scalableFont(size: 13, weight: .regular)
                }

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "person.3.fill")
                        .scalableFont(size: 14, weight: .semibold)
                    Text("10 People Ahead")
                        .scalableFont(size: 13, weight: .regular)
                }
            }
            .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))
            .padding(.top, 22)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 26)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.gray.opacity(0.13), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.13), radius: 14, x: 0, y: 8)
    }

}

#Preview {
    QRTokenView()
}
