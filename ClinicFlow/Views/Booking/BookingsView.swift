import SwiftUI

// MARK: - Model
struct Booking: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let doctorName: String
    let specialty: String
    let bookingID: String
    let imagePlaceholder: String   // SF Symbol used as placeholder
    let doctorImage: String        // Asset catalog image name
    var remindMe: Bool
}

// MARK: - View
struct BookingsView: View {
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var voiceGuidance: VoiceGuidanceManager

    @State private var showDoctorProfile = false
    @State private var selectedBookingIdx: Int = 0

    @State private var bookings: [Booking] = [
        Booking(date: "Feb 25, 2026", time: "10:00 AM",
                doctorName: "Prof. Namal Wijesinghe",
                specialty: "MBBS, Dermatologist specialist",
                bookingID: "#58-68237F",
                imagePlaceholder: "person.crop.square.fill",
                doctorImage: "namal",
                remindMe: true),
        Booking(date: "Mar 02, 2026", time: "02:30 PM",
                doctorName: "Dr. Sarah Mitchell",
                specialty: "MD, Cardiologist",
                bookingID: "#58-68238A",
                imagePlaceholder: "person.crop.square.fill",
                doctorImage: "sarah",
                remindMe: false),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Booking cards
                        VStack(spacing: 16) {
                            ForEach(Array(bookings.enumerated()), id: \.element.id) { idx, booking in
                                bookingCard(idx: idx, booking: booking)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 16)

                        Spacer(minLength: 20)
                    }
                }

            }
        }
        .clinicNavBar(title: "Bookings", onBack: { tabRouter.selectedTab = .home })
        .onAppear {
            voiceGuidance.announceScreen(title: "My Bookings", instructions: "You have \(bookings.count) upcoming doctor appointments. Scroll through to view details or book a new appointment.")
        }
        .navigationDestination(isPresented: $showDoctorProfile) {
            if selectedBookingIdx < bookings.count {
                let booking = bookings[selectedBookingIdx]
                let specialist = Specialist(
                    name: booking.doctorName,
                    subtitle: booking.specialty,
                    rating: 4,
                    reviews: 89,
                    imageAsset: booking.doctorImage,
                    imageSymbol: "person.crop.circle.fill",
                    experience: "8 yrs",
                    available: true
                )
                DoctorProfileView(specialist: specialist)
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Booking card
    // ─────────────────────────────────────────────────────────────────────────
    private func bookingCard(idx: Int, booking: Booking) -> some View {
        VStack(spacing: 0) {

            // ── Row 1: date pill + remind me toggle ───────────────────────
            HStack(spacing: 12) {
                // Date/time pill
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .scalableFont(size: 13, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                    Text("\(booking.date) · \(booking.time)")
                        .scalableFont(size: 13, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(Color(.systemGray6))
                )

                Spacer()

                // Remind me
                VStack(spacing: 2) {
                    Text("Remind")
                        .scalableFont(size: 11, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                    Text("me")
                        .scalableFont(size: 11, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                }

                Toggle("", isOn: Binding(
                    get: { bookings[idx].remindMe },
                    set: { newVal in withAnimation(.none) { bookings[idx].remindMe = newVal } }
                ))
                .labelsHidden()
                .tint(.brand)
                .scaleEffect(0.85)
                .animation(.none, value: bookings[idx].remindMe)
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 16)

            Divider().padding(.horizontal, 18)

            // ── Row 2: doctor info ────────────────────────────────────────
            HStack(alignment: .center, spacing: 14) {
                // Doctor avatar
                Image(booking.doctorImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(booking.doctorName)
                        .scalableFont(size: 15, weight: .bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(booking.specialty)
                        .scalableFont(size: 12)
                        .foregroundColor(Color(.secondaryLabel))
                        .lineLimit(1)
                    Text("Booking ID: \(booking.bookingID)")
                        .scalableFont(size: 11)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Three-dot menu
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .scalableFont(size: 14, weight: .medium)
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(width: 32, height: 32)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 18)

            Divider().padding(.horizontal, 18)

            // ── Row 3: action buttons ────────────────────────────────────
            HStack(spacing: 12) {
                // Decline
                Button(action: {}) {
                    Text("Decline")
                        .scalableFont(size: 15, weight: .semibold)
                        .foregroundColor(.brand)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.brand, lineWidth: 1.5)
                        )
                }
                .buttonStyle(.plain)

                // View
                Button(action: {
                    selectedBookingIdx = idx
                    showDoctorProfile = true
                }) {
                    Text("View")
                        .scalableFont(size: 15, weight: .semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.brand)
                        )
                        .shadow(color: Color.brand.opacity(0.28), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 5)
        )
    }

}

// MARK: - Preview
#Preview {
    BookingsView()
}
