import SwiftUI

// MARK: - Uploaded File Model
private struct UploadedFile: Identifiable {
    let id = UUID()
    let name: String
    let size: String
}

// MARK: - Upload Prescription View
struct UploadPrescriptionView: View {
    @Environment(\.dismiss) private var dismiss
    var onDone: (() -> Void)? = nil

    @State private var uploadedFiles: [UploadedFile] = [
        UploadedFile(name: "Prescription_2026-02-23.jpg", size: "2.4 MB")
    ]
    @State private var navigateToPharmacy = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // ── Already Uploaded banner ───────────────────
                    alreadyUploadedBanner

                    // ── Upload area ───────────────────────────────
                    uploadAreaCard

                    // ── Uploaded files list ───────────────────────
                    if !uploadedFiles.isEmpty {
                        uploadedFilesSection
                    }

                    // ── Submit Prescription button ────────────────
                    submitButton

                    // ── Instructions ─────────────────────────────
                    instructionsCard
                    
                    // Add extra space at the bottom for scrolling
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(Color(.systemGray6))
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Upload Prescription", onBack: { dismiss() })
        .navigationDestination(isPresented: $navigateToPharmacy) {
            PharmacyView(onDone: onDone)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Already Uploaded Banner
    // ─────────────────────────────────────────────────────────────────────────
    private var alreadyUploadedBanner: some View {
        HStack {
            Text("Already Uploaded")
                .scalableFont(size: 16, weight: .medium)
                .foregroundColor(.white)
            Spacer()
            Button(action: { navigateToPharmacy = true }) {
                Text("GO")
                    .scalableFont(size: 14, weight: .bold)
                    .foregroundColor(Color.brand)
                    .frame(width: 68, height: 36)
                    .background(
                        Capsule().fill(Color.white)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.brand)
                .shadow(color: Color.brand.opacity(0.25), radius: 12, x: 0, y: 5)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Upload Area Card
    // ─────────────────────────────────────────────────────────────────────────
    private var uploadAreaCard: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.10))
                    .frame(width: 76, height: 76)
                Image(systemName: "doc.badge.plus")
                    .scalableFont(size: 28, weight: .medium)
                    .foregroundColor(.brand)
            }

            VStack(spacing: 8) {
                Text("Add your prescription")
                    .scalableFont(size: 20, weight: .semibold)
                    .foregroundColor(.primary)
                Text("Upload a clear photo or PDF of your doctor's\nprescription for this visit.")
                    .scalableFont(size: 14, weight: .regular)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            // Take Photo button (outline)
            Button(action: {}) {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .scalableFont(size: 15, weight: .semibold)
                    Text("Take Photo")
                        .scalableFont(size: 16, weight: .semibold)
                }
                .foregroundColor(.brand)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Capsule()
                        .strokeBorder(Color.brand, lineWidth: 1.5)
                        .background(Capsule().fill(Color.white))
                )
            }
            .buttonStyle(.plain)

            // Upload File button (filled)
            Button(action: {}) {
                HStack(spacing: 10) {
                    Image(systemName: "doc.badge.arrow.up.fill")
                        .scalableFont(size: 15, weight: .semibold)
                    Text("Upload File")
                        .scalableFont(size: 16, weight: .semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Capsule()
                        .fill(
                            Color.brand
                        )
                        .shadow(color: Color.brand.opacity(0.30), radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(.plain)

            Text("Supported formats: JPG, PNG, PDF  •  Max 5 MB")
                .scalableFont(size: 12, weight: .regular)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Uploaded Files Section
    // ─────────────────────────────────────────────────────────────────────────
    private var uploadedFilesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Uploaded Prescriptions")
                .scalableFont(size: 16, weight: .semibold)
                .foregroundColor(.primary)

            VStack(spacing: 10) {
                ForEach(uploadedFiles) { file in
                    fileRow(file)
                }
            }
        }
    }

    private func fileRow(_ file: UploadedFile) -> some View {
        HStack(spacing: 14) {
            // File icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.brand.opacity(0.10))
                    .frame(width: 46, height: 46)
                Image(systemName: "photo.fill")
                    .scalableFont(size: 18, weight: .medium)
                    .foregroundColor(.brand)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(file.name)
                    .scalableFont(size: 14, weight: .medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(file.size)
                    .scalableFont(size: 12, weight: .regular)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Remove button
            Button(action: {
                withAnimation(.spring(response: 0.28)) {
                    uploadedFiles.removeAll { $0.id == file.id }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.92, blue: 0.92))
                        .frame(width: 32, height: 32)
                    Image(systemName: "xmark")
                        .scalableFont(size: 11, weight: .bold)
                        .foregroundColor(Color(red: 0.90, green: 0.20, blue: 0.20))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Instructions Card
    // ─────────────────────────────────────────────────────────────────────────
    private var instructionsCard: some View {
        HStack(alignment: .top, spacing: 0) {
            // Blue left accent bar
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color.brand)
                .frame(width: 4)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .scalableFont(size: 16, weight: .medium)
                        .foregroundColor(.brand)
                    Text("Instructions")
                        .scalableFont(size: 15, weight: .semibold)
                        .foregroundColor(.primary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    instructionBullet("Make sure all medicine names and dosages are clearly visible.")
                    instructionBullet("Include doctor's signature and date.")
                    instructionBullet("Upload only prescriptions issued within the last 7 days for this visit.")
                }
            }
            .padding(.leading, 14)
            .padding(.trailing, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.brand.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.brand.opacity(0.12), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func instructionBullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.brand)
                .frame(width: 5, height: 5)
                .padding(.top, 6)
            Text(text)
                .scalableFont(size: 13, weight: .regular)
                .foregroundColor(Color(.secondaryLabel))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Submit Button
    // ─────────────────────────────────────────────────────────────────────────
    private var submitButton: some View {
        Button(action: { navigateToPharmacy = true }) {
            Text("Submit Prescription")
                .scalableFont(size: 16, weight: .semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.brand)
                        .shadow(color: Color.brand.opacity(0.30), radius: 10, x: 0, y: 4)
                )
        }
        .buttonStyle(.plain)
    }

}

// MARK: - Preview
#Preview {
    UploadPrescriptionView()
}
