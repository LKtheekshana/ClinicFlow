import SwiftUI

// MARK: - Model
struct LabTest: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var isSelected: Bool = false
}

// MARK: - All Tests View
struct AllTestsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var voiceGuidance: VoiceGuidanceManager
    var onDone: (() -> Void)? = nil
    @Namespace private var tabNamespace

    @State private var selectedTab: Int = 0
    @State private var navigateToPayment = false
    @State private var navigateToInstructions = false
    @State private var navigateToLabView = false

    @State private var tests: [LabTest] = [
        LabTest(name: "Comprehensive Full Body Checkup", icon: "heart.text.square.fill"),
        LabTest(name: "Fasting Blood Sugar",             icon: "drop.fill",              isSelected: true),
        LabTest(name: "Lipid Profile",                   icon: "pencil.and.list.clipboard"),
        LabTest(name: "Thyroid Function Test",           icon: "hourglass",              isSelected: true),
        LabTest(name: "Complete Blood Count",            icon: "microbe.fill"),
        LabTest(name: "Vitamin D Test",                  icon: "plus.circle.fill"),
    ]

    private var requiredTests: [LabTest] { tests.filter(\.isSelected) }

    var body: some View {
        VStack(spacing: 0) {
            // Sticky segment header
            VStack(spacing: 0) {
                segmentControl
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
            }
            .background(Color(.systemGray6))

            // Animated list
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        Color.clear.frame(height: 0).id("top")

                        if selectedTab == 0 {
                            ForEach(Array(tests.enumerated()), id: \.element.id) { idx, test in
                                testRow(test: test, index: idx, isMutable: true)
                                    .padding(.horizontal, 20)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .leading).combined(with: .opacity),
                                        removal:   .move(edge: .trailing).combined(with: .opacity)
                                    ))
                            }
                        } else {
                            if requiredTests.isEmpty {
                                emptyState
                                    .padding(.horizontal, 20)
                                    .padding(.top, 40)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal:   .move(edge: .leading).combined(with: .opacity)
                                    ))
                            } else {
                                ForEach(requiredTests) { test in
                                    testRow(
                                        test: test,
                                        index: tests.firstIndex(where: { $0.id == test.id }) ?? 0,
                                        isMutable: false
                                    )
                                    .padding(.horizontal, 20)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal:   .move(edge: .leading).combined(with: .opacity)
                                    ))
                                }
                            }
                        }

                        // Continue → Lab Payment
                        Button(action: { navigateToPayment = true }) {
                            Text("Continue")
                                .scalableFont(size: 16, weight: .semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.brand)
                                        .shadow(color: Color.brand.opacity(0.28), radius: 10, x: 0, y: 4)
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        // Go to Lab View shortcut
                        Button(action: { navigateToLabView = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "flask.fill")
                                    .scalableFont(size: 14, weight: .medium)
                                Text("Go to Lab View")
                                    .scalableFont(size: 15, weight: .medium)
                            }
                            .foregroundColor(.brand)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        .padding(.bottom, 110)
                    }
                    .padding(.top, 4)
                }
                .onChange(of: selectedTab) { _ in
                    withAnimation(.easeOut(duration: 0.15)) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .clinicNavBar(title: "Tests", onBack: { dismiss() }) {
            ToolbarCircleButton(icon: "questionmark", action: { navigateToInstructions = true })
        }
        .onAppear {
            voiceGuidance.announceScreen(title: "Select Lab Tests", instructions: "Choose from \(tests.count) available tests. Currently \(requiredTests.count) selected. Tap Continue to proceed to payment.")
        }
        .navigationDestination(isPresented: $navigateToPayment) {
            LabPaymentView(selectedTests: tests.filter(\.isSelected), onDone: onDone)
        }
        .navigationDestination(isPresented: $navigateToLabView) {
            LabView(onDone: onDone)
        }
        .navigationDestination(isPresented: $navigateToInstructions) {
            TestInstructionsView()
        }
    }

    // MARK: Segment control (matchedGeometryEffect sliding pill)
    private var segmentControl: some View {
        HStack(spacing: 10) {
            segmentButton(title: "All Tests",      tag: 0)
            segmentButton(title: "Required Tests", tag: 1)
        }
    }

    private func segmentButton(title: String, tag: Int) -> some View {
        Button(action: { switchTab(to: tag) }) {
            ZStack {
                if selectedTab == tag {
                    Capsule()
                        .fill(Color.brand)
                        .matchedGeometryEffect(id: "pill", in: tabNamespace)
                        .shadow(color: Color.brand.opacity(0.30), radius: 6, x: 0, y: 3)
                } else {
                    Capsule()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                }
                Text(title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(selectedTab == tag ? .white : Color(.label))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 46)
        }
        .buttonStyle(.plain)
    }

    private func switchTab(to tab: Int) {
        guard tab != selectedTab else { return }
        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
            selectedTab = tab
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK: Test row
    // ─────────────────────────────────────────────────────────────────────────
    private func testRow(test: LabTest, index: Int, isMutable: Bool) -> some View {
        HStack(spacing: 16) {
            // Icon circle
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

            // Selection circle / checkmark
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
        .contentShape(Rectangle())
        .onTapGesture {
            guard isMutable else { return }
            withAnimation(.spring(response: 0.22)) {
                tests[index].isSelected.toggle()
            }
        }
    }

    // MARK: Empty state
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.08))
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark.circle")
                    .scalableFont(size: 30, weight: .medium)
                    .foregroundColor(Color.brand.opacity(0.5))
            }
            Text("No tests selected")
                .scalableFont(size: 16, weight: .semibold)
                .foregroundColor(.primary)
            Text("Go to All Tests and select the\ntests you need.")
                .scalableFont(size: 14)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
            Button(action: { switchTab(to: 0) }) {
                Text("Select Tests")
                    .scalableFont(size: 14, weight: .semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.brand))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }

}

// MARK: - Preview
#Preview {
    AllTestsView()
}
