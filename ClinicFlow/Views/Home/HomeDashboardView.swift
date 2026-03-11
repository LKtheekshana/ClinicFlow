import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject private var tabRouter: TabRouter
    @State private var navigateToPatientDetails = false
    @State private var navigateToConsultation = false
    @State private var navigateToPharmacy = false
    @State private var navigateToLab = false
    @State private var navigateToDirections = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        specialtySection
                            .padding(.top, 14)

                        appointmentCard
                            .padding(.horizontal, 24)
                            .padding(.top, 20)

                        servicesSection
                            .padding(.top, 26)

                        Spacer(minLength: 90)
                    }
                }

            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToPatientDetails) {
            PatientDetailsView(onDone: { navigateToPatientDetails = false })
        }
        .navigationDestination(isPresented: $navigateToConsultation) {
            ConsultationView(onDone: { navigateToConsultation = false })
        }
        .navigationDestination(isPresented: $navigateToPharmacy) {
            UploadPrescriptionView(onDone: { navigateToPharmacy = false })
        }
        .navigationDestination(isPresented: $navigateToLab) {
            AllTestsView(onDone: { navigateToLab = false })
        }
        .navigationDestination(isPresented: $navigateToDirections) {
            DirectionsView()
        }

    }

    private var specialtySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("The Doctor Specialties")
                    .font(.system(size: 42 / 2, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.22))

                Spacer()

                Button("See all") {
                }
                .font(.system(size: 36 / 2, weight: .medium))
                .foregroundColor(.brand)
            }
            .padding(.horizontal, 24)

            HStack(spacing: 20) {
                SpecialtyItem(icon: "heart.text.square.fill", title: "Cardio")
                SpecialtyItem(icon: "lungs.fill", title: "Lungs")
                SpecialtyItem(icon: "brain.head.profile", title: "Brain")
                SpecialtyItem(icon: "questionmark.circle.dashed", title: "Acidity")
            }
            .padding(.horizontal, 24)
        }
    }

    private var appointmentCard: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.22, green: 0.56, blue: 0.96),
                    Color(red: 0.15, green: 0.39, blue: 0.86)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Schedule an\nappointment with your\npreferred specialist")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineSpacing(4)

                    Button {
                        navigateToPatientDetails = true
                    } label: {
                        Text("Book\nAppointments")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.brand)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: 210)
                }

                Spacer(minLength: 8)

                Image("hero_banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 180)
                    .clipped()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
        }
        .frame(minHeight: 244)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.brand.opacity(0.22), radius: 14, x: 0, y: 8)
    }

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Our Services")
                    .font(.system(size: 44 / 2, weight: .medium))
                    .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.22))

                Spacer()

                Button("See all") {
                }
                .font(.system(size: 36 / 2, weight: .medium))
                .foregroundColor(.brand)
            }
            .padding(.horizontal, 24)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ServiceItem(icon: "stethoscope", title: "Consultation", subtitle: "See a specialist") {
                    navigateToConsultation = true
                }
                ServiceItem(icon: "location.north.circle", title: "Directions", subtitle: "Book your doctor") {
                    navigateToDirections = true
                }
                ServiceItem(icon: "flask", title: "Laboratory", subtitle: "View test reports") {
                    navigateToLab = true
                }
                ServiceItem(icon: "pills.fill", title: "Pharmacy", subtitle: "Order medicines") {
                    navigateToPharmacy = true
                }
            }
            .padding(.horizontal, 24)
        }
    }

}

private struct SpecialtyItem: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color.brand.opacity(0.08))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.brand)
                )

            Text(title)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(red: 0.20, green: 0.23, blue: 0.30))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ServiceItem: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: () -> Void = {}

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brand.opacity(0.08))
                    .frame(width: 52, height: 52)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.brand)
                    )

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.22))

                HStack {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(red: 0.60, green: 0.62, blue: 0.71))

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.system(size: 24 / 2, weight: .bold))
                        .foregroundColor(.brand)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 155)
            .background(Color.white.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

#Preview {
    HomeDashboardView()
}
