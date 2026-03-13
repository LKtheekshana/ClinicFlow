import SwiftUI
import CoreImage.CIFilterBuiltins

struct ConsultationView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil
    @State private var navigateToDirections = false
    @State private var showQR = false

    private let tokenNumber = "055"

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                mapPanel
                    .padding(.horizontal, 24)
                    .padding(.top, 18)

                tokenPanel
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                Button {
                    onDone?()
                } label: {
                    Text("Done")
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
                .padding(.bottom, 110)
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Consultation", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToDirections) {
            DirectionsView()
        }
        .sheet(isPresented: $showQR) {
            QROverlayView(tokenNumber: tokenNumber)
                .presentationDetents([.medium])
                .presentationCornerRadius(28)
        }
    }



    private var mapPanel: some View {
        ZStack {
            Image("map")
                .resizable()
                .scaledToFill()

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)

            VStack {
                HStack {
                    Spacer()

                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.brand)
                            .frame(width: 16, height: 16)

                        Text("Precise: On")
                            .scalableFont(size: 11, weight: .medium)
                            .foregroundStyle(Color(red: 0.17, green: 0.19, blue: 0.24))
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 28)
                    .background(Color.white.opacity(0.94))
                    .clipShape(Capsule())
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { navigateToDirections = true }
    }

    private var tokenPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                Button { showQR = true } label: {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(red: 0.94, green: 0.95, blue: 0.98))
                        .frame(width: 62, height: 62)
                        .overlay(
                            Image(systemName: "qrcode")
                                .scalableFont(size: 28, weight: .medium)
                                .foregroundStyle(Color(red: 0.17, green: 0.19, blue: 0.23))
                        )
                }
                .buttonStyle(.plain)
            }

            Text("Your Token Number")
                .scalableFont(size: 14, weight: .medium)
                .foregroundStyle(Color(red: 0.43, green: 0.47, blue: 0.56))
                .padding(.top, 6)

            Text(tokenNumber)
                .scalableFont(size: 42, weight: .bold)
                .foregroundStyle(Color(red: 0.07, green: 0.09, blue: 0.14))
                .padding(.top, 6)

            HStack(spacing: 10) {
                Spacer(minLength: 0)
                TokenGhost(value: "048", size: 50)
                TokenGhost(value: "049", size: 50)

                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.brand)
                        .frame(width: 64, height: 64)
                        .shadow(color: Color.brand.opacity(0.18), radius: 8, x: 0, y: 4)
                        .overlay(
                            Text(tokenNumber)
                                .scalableFont(size: 15, weight: .bold)
                                .foregroundStyle(.white)
                        )

                    Text("Now")
                        .scalableFont(size: 12, weight: .semibold)
                        .foregroundStyle(.brand)
                }

                TokenGhost(value: "056", size: 50)
                TokenGhost(value: "057", size: 50)
                Spacer(minLength: 0)
            }
            .padding(.top, 22)

            Divider()
                .padding(.top, 24)

            HStack(spacing: 0) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "clock")
                                .scalableFont(size: 14, weight: .semibold)
                                .foregroundStyle(Color.orange)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Est. Wait")
                            .scalableFont(size: 12, weight: .regular)
                            .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))

                        Text("25 min")
                            .scalableFont(size: 15, weight: .bold)
                            .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.20))
                    }
                }

                Spacer()

                Rectangle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 1, height: 36)

                Spacer()

                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.brand.opacity(0.12))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person")
                                .scalableFont(size: 14, weight: .semibold)
                                .foregroundStyle(.brand)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ahead")
                            .scalableFont(size: 12, weight: .regular)
                            .foregroundStyle(Color(red: 0.56, green: 0.58, blue: 0.64))

                        Text("10 People")
                            .scalableFont(size: 15, weight: .bold)
                            .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.20))
                    }
                }
            }
            .padding(.top, 22)
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.gray.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

}

// MARK: - QR Overlay

private struct QROverlayView: View {
    let tokenNumber: String

    var qrImage: UIImage? {
        let context  = CIContext()
        let filter   = CIFilter.qrCodeGenerator()
        filter.message = Data((tokenNumber).utf8)
        filter.correctionLevel = "H"
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    var body: some View {
        VStack(spacing: 24) {
            // Handle bar
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            Text("Your Token QR Code")
                .scalableFont(size: 18, weight: .semibold)
                .foregroundStyle(Color(red: 0.07, green: 0.09, blue: 0.14))

            if let img = qrImage {
                Image(uiImage: img)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 6)
                    )
            }

            VStack(spacing: 4) {
                Text("Token Number")
                    .scalableFont(size: 13)
                    .foregroundStyle(Color(.secondaryLabel))
                Text(tokenNumber)
                    .scalableFont(size: 36, weight: .bold)
                    .foregroundStyle(Color.brand)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - Ghost token bubble

private struct TokenGhost: View {
    let value: String
    var size: CGFloat = 50

    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.13))
            .frame(width: size, height: size)
            .overlay(
                Text(value)
                    .scalableFont(size: 13, weight: .semibold)
                    .foregroundStyle(Color(red: 0.60, green: 0.63, blue: 0.70))
            )
    }
}

#Preview {
    ConsultationView()
}
