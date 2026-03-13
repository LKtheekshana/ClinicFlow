import SwiftUI

// MARK: - Step Model
private struct DirectionStep: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}

// MARK: - Get Direction View
struct GetDirectionView: View {
    @Environment(\.dismiss) private var dismiss

    let from: String
    let to: String
    @State private var currentStep: Int = 1
    @State private var guidanceStarted = false

    private let duration = "Approx. 3–5 min"
    private let distance = "~150m"

    private let steps: [DirectionStep] = [
        DirectionStep(
            title: "From Main Entrance, walk straight to Reception desk",
            detail: "Follow the blue floor line until you see the 'Reception' sign on your left"
        ),
        DirectionStep(
            title: "At Reception, turn right towards the main corridor",
            detail: "Pass the Pharmacy on your right and keep going straight"
        ),
        DirectionStep(
            title: "Continue straight until Emergency Room junction",
            detail: "You'll see signs for Emergency Room and Ward 3B"
        ),
        DirectionStep(
            title: "Turn left at Emergency Room sign",
            detail: "Stay on the left side; elevators will be on your right"
        ),
        DirectionStep(
            title: "Lab will be on your left after Ward 3B",
            detail: "Look for the 'Lab' sign and glass double doors"
        ),
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // From / To strip
                fromToStrip
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)

                Divider()

                // Step-by-step
                VStack(alignment: .leading, spacing: 0) {
                    Text("Step-by-step directions")
                        .scalableFont(size: 18, weight: .bold)
                        .foregroundColor(.primary)
                        .padding(.top, 24)
                        .padding(.bottom, 20)

                    ForEach(Array(steps.enumerated()), id: \.element.id) { idx, step in
                        stepRow(step: step, number: idx + 1, isLast: idx == steps.count - 1)
                    }
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.top, 24)

                // You are here chip
                HStack(spacing: 10) {
                    Image(systemName: "location.fill")
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundColor(.brand)
                    Text(guidanceStarted
                         ? "You are here – Step \(currentStep)"
                         : "You are here – Step 1")
                        .scalableFont(size: 14, weight: .semibold)
                        .foregroundColor(.brand)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.brand.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.brand.opacity(0.18), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Start Guidance / Next Step button
                Button(action: {
                    if currentStep == steps.count && guidanceStarted {
                        dismiss()
                    } else {
                        withAnimation(.spring(response: 0.25)) {
                            if !guidanceStarted {
                                guidanceStarted = true
                            } else if currentStep < steps.count {
                                currentStep += 1
                            }
                        }
                    }
                }) {
                    Text(guidanceStarted
                         ? (currentStep < steps.count ? "Next Step →" : "Arrived!")
                         : "Start Guidance")
                        .scalableFont(size: 16, weight: .semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    currentStep == steps.count && guidanceStarted
                                        ? Color(red: 0.18, green: 0.70, blue: 0.44)
                                        : Color.brand
                                )
                                .shadow(color: Color.brand.opacity(0.28), radius: 10, x: 0, y: 4)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 110)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .clinicNavBar(title: "Get Direction", onBack: { dismiss() })
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: From / To Strip
    // ─────────────────────────────────────────────────────────────────────────
    private var fromToStrip: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("From:")
                        .scalableFont(size: 12, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(from)
                        .scalableFont(size: 17, weight: .semibold)
                        .foregroundColor(.primary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("To:")
                        .scalableFont(size: 12, weight: .regular)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(to)
                        .scalableFont(size: 17, weight: .semibold)
                        .foregroundColor(.primary)
                }
            }

            HStack(spacing: 20) {
                Text(duration)
                    .scalableFont(size: 14, weight: .semibold)
                    .foregroundColor(.brand)
                Text(distance)
                    .scalableFont(size: 14, weight: .regular)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Step Row
    // ─────────────────────────────────────────────────────────────────────────
    private func stepRow(step: DirectionStep, number: Int, isLast: Bool) -> some View {
        let isActive = number == currentStep
        let isDone   = number < currentStep

        return HStack(alignment: .top, spacing: 16) {
            // Number circle + connector line
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isActive ? Color.brand : (isDone ? Color(red: 0.18, green: 0.70, blue: 0.44) : Color(.systemGray5)))
                        .frame(width: 34, height: 34)
                    if isDone {
                        Image(systemName: "checkmark")
                            .scalableFont(size: 13, weight: .bold)
                            .foregroundColor(.white)
                    } else {
                        Text("\(number)")
                            .scalableFont(size: 14, weight: .bold)
                            .foregroundColor(isActive ? .white : Color(.secondaryLabel))
                    }
                }

                if !isLast {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 1.5)
                        .frame(minHeight: 36)
                        .padding(.vertical, 4)
                }
            }

            // Text content
            VStack(alignment: .leading, spacing: 5) {
                Text(step.title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(step.detail)
                    .scalableFont(size: 13, weight: .regular)
                    .foregroundColor(Color(.secondaryLabel))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 6)
            .padding(.bottom, isLast ? 0 : 12)
        }
    }

}


// MARK: - Preview
#Preview {
    GetDirectionView(from: "Main Entrance", to: "Lab")
}
