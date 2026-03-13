import SwiftUI

// MARK: - Required Tests View
struct RequiredTestsView: View {
    @Environment(\.dismiss) private var dismiss

    let requiredTests: [LabTest]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Segment tabs
                            segmentTabs
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 24)

                            // Test list (only required / selected tests)
                            VStack(spacing: 10) {
                                ForEach(requiredTests) { test in
                                    testRow(test: test)
                                        .padding(.horizontal, 20)
                                }
                            }

                            Spacer(minLength: 100 + geo.safeAreaInsets.bottom)
                        }
                    }

                    bottomArea(geo: geo)
                }
            }
        }
        .clinicNavBar(title: "Tests", onBack: { dismiss() })
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Segment tabs (Required Tests is active)
    // ─────────────────────────────────────────────────────────────────────────
    private var segmentTabs: some View {
        HStack(spacing: 0) {
            // All Tests – tapping goes back
            Button(action: { dismiss() }) {
                Text("All Tests")
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(Color(.secondaryLabel))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Capsule().fill(Color.clear))
            }
            .buttonStyle(.plain)

            // Required Tests – active
            Text("Required Tests")
                .scalableFont(size: 15, weight: .semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Capsule().fill(Color.brand))
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Test row
    // ─────────────────────────────────────────────────────────────────────────
    private func testRow(test: LabTest) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(test.isSelected
                          ? Color.brand.opacity(0.10)
                          : Color(.systemGray6))
                    .frame(width: 46, height: 46)
                Image(systemName: test.icon)
                    .scalableFont(size: 18, weight: .medium)
                    .foregroundColor(test.isSelected ? .brand : Color(.secondaryLabel))
            }

            Text(test.name)
                .scalableFont(size: 15, weight: .medium)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            ZStack {
                Circle()
                    .strokeBorder(test.isSelected ? Color.brand : Color(.systemGray3), lineWidth: 1.5)
                    .background(Circle().fill(test.isSelected ? Color.brand : Color.white))
                    .frame(width: 26, height: 26)
                if test.isSelected {
                    Image(systemName: "checkmark")
                        .scalableFont(size: 12, weight: .bold)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(test.isSelected ? Color.brand.opacity(0.50) : Color.clear,
                                      lineWidth: 1.5)
                )
                .shadow(color: test.isSelected ? Color.brand.opacity(0.10) : .black.opacity(0.05),
                        radius: 8, x: 0, y: 3)
        )
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Bottom area
    // ─────────────────────────────────────────────────────────────────────────
    private func bottomArea(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color(.systemGray5)).frame(height: 0.8)

            Button(action: {}) {
                Text("Continue")
                    .scalableFont(size: 16, weight: .semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.brand)
                    )
                    .shadow(color: Color.brand.opacity(0.28), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 12)
        }
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }

}

// MARK: - Preview
#Preview {
    RequiredTestsView(requiredTests: [
        LabTest(name: "Fasting Blood Sugar",    icon: "drop.fill",   isSelected: true),
        LabTest(name: "Thyroid Function Test",  icon: "hourglass",   isSelected: true),
    ])
}
