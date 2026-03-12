import SwiftUI

// Models

private enum InstructionItemType {
    case bullet
    case callout(style: CalloutStyle)
}

private enum CalloutStyle {
    case info    // blue
    case warning // orange
}

private struct InstructionItem: Identifiable {
    let id = UUID()
    let title: String?
    let body: String
    let type: InstructionItemType
}

private struct InstructionSection: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let items: [InstructionItem]
    let footer: String?
}

// Data

private let sections: [InstructionSection] = [
    InstructionSection(number: 1, title: "Preparation: Dos and Don'ts", items: [
        InstructionItem(title: "Fasting Blood Sugar / Lipid Profile:",
                        body: "Do not eat or drink anything except water for 10–12 hours before the test. This ensures accurate glucose and cholesterol readings.",
                        type: .bullet),
        InstructionItem(title: "Thyroid / Vitamin Tests:",
                        body: "No special preparation needed, but early morning slots are recommended for consistency with reference ranges.",
                        type: .bullet),
        InstructionItem(title: "Hydration:",
                        body: "Drink 2–3 glasses of water before sample collection (unless strictly fasting). This makes veins more visible and sample collection easier.",
                        type: .bullet),
        InstructionItem(title: "Medication:",
                        body: "Inform the technician if you are on any blood thinners or regular medication. Do not stop medication without a doctor's advice.",
                        type: .callout(style: .info)),
        InstructionItem(title: "Avoid Alcohol:",
                        body: "Refrain from consuming alcohol for at least 24 hours before liver function tests or lipid profile tests.",
                        type: .bullet),
        InstructionItem(title: "Rest Well:",
                        body: "Get adequate sleep the night before your test. Fatigue can affect certain blood parameters.",
                        type: .bullet),
        InstructionItem(title: "Exercise:",
                        body: "Avoid strenuous exercise 24 hours before the test as it may temporarily alter certain enzyme levels.",
                        type: .callout(style: .warning)),
    ], footer: nil),

    InstructionSection(number: 2, title: "On the Day of Test", items: [
        InstructionItem(title: "Arrive on Time:",
                        body: "Please arrive 5–10 minutes before your scheduled appointment to complete any necessary paperwork.",
                        type: .bullet),
        InstructionItem(title: "Bring Documents:",
                        body: "Carry your booking confirmation, prescription (if any), and a valid photo ID.",
                        type: .bullet),
        InstructionItem(title: "Wear Comfortable Clothing:",
                        body: "Choose loose-sleeved clothing for easy access to your arm for blood collection.",
                        type: .bullet),
        InstructionItem(title: "Relax:",
                        body: "Try to stay calm. Anxiety can temporarily affect blood pressure and heart rate readings.",
                        type: .bullet),
    ], footer: nil),

    InstructionSection(number: 3, title: "After Sample Collection", items: [
        InstructionItem(title: "Apply Pressure:",
                        body: "Keep the cotton ball pressed on the puncture site for 2–3 minutes to prevent bruising.",
                        type: .bullet),
        InstructionItem(title: "Eat Something:",
                        body: "If you were fasting, have a light snack or meal to restore your energy levels.",
                        type: .bullet),
        InstructionItem(title: "Stay Hydrated:",
                        body: "Drink plenty of water throughout the day to help your body recover.",
                        type: .bullet),
        InstructionItem(title: "Results:",
                        body: "Your test results will typically be available within 24–48 hours. You'll receive a notification in the app when they're ready.",
                        type: .bullet),
    ], footer: "If you experience any unusual symptoms after the test, such as excessive bleeding, swelling, or dizziness, please contact our support team immediately."),
]

//  View

struct TestInstructionsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(sections) { section in
                    SectionBlock(section: section)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 110)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .clinicNavBar(title: "Instructions", onBack: { dismiss() }) {
            ToolbarCircleButton(icon: "square.and.arrow.up", action: {
                shareInstructions()
            })
        }
    }

    private func shareInstructions() {
        let text = """
        Test Preparation Instructions

        1. Preparation: Dos and Don'ts
        • Fast 10–12 hours for blood sugar/lipid tests.
        • Hydrate well unless fasting.
        • Inform technician of any medications.
        • Avoid alcohol 24 hrs before liver/lipid tests.
        • Avoid strenuous exercise 24 hrs before.

        2. On the Day of Test
        • Arrive 5–10 mins early.
        • Bring booking confirmation & valid photo ID.
        • Wear loose-sleeved clothing.

        3. After Sample Collection
        • Apply pressure for 2–3 mins.
        • Eat something if you were fasting.
        • Stay hydrated.
        • Results ready within 24–48 hours.
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }
}

// Section Block

private struct SectionBlock: View {
    let section: InstructionSection

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Section header
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.brand)
                        .frame(width: 30, height: 30)
                    Text("\(section.number)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(section.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(.label))
            }

            // Items
            VStack(alignment: .leading, spacing: 10) {
                ForEach(section.items) { item in
                    InstructionRow(item: item)
                }
            }

            // Footer
            if let footer = section.footer {
                SectionFooter(text: footer)
            }
        }
    }
}

//Instruction Row

private struct InstructionRow: View {
    let item: InstructionItem

    var body: some View {
        switch item.type {
        case .bullet:
            BulletRow(item: item)
        case .callout(let style):
            CalloutRow(item: item, style: style)
        }
    }
}

// Bullet Row

private struct BulletRow: View {
    let item: InstructionItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(.label))
                .frame(width: 5, height: 5)
                .padding(.top, 8)

            bodyText
        }
    }

    private var bodyText: some View {
        Group {
            if let title = item.title {
                Text("\(Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(Color(.label))) \(Text(item.body).font(.system(size: 15, weight: .regular)).foregroundColor(Color(.secondaryLabel)))")
            } else {
                Text(item.body)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        .lineSpacing(3)
    }
}

// Callout Row

private struct CalloutRow: View {
    let item: InstructionItem
    let style: CalloutStyle

    private var accentColor: Color {
        switch style {
        case .info:    return Color(red: 0.13, green: 0.48, blue: 0.97)
        case .warning: return Color(red: 0.96, green: 0.56, blue: 0.13)
        }
    }

    private var bgColor: Color {
        switch style {
        case .info:    return Color(red: 0.13, green: 0.48, blue: 0.97).opacity(0.07)
        case .warning: return Color(red: 0.96, green: 0.56, blue: 0.13).opacity(0.08)
        }
    }

    private var iconName: String {
        switch style {
        case .info:    return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 3)
                .padding(.vertical, 12)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(accentColor)
                    .padding(.top, 12)

                bodyText
                    .padding(.vertical, 12)
                    .padding(.trailing, 14)
            }
            .padding(.leading, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var bodyText: some View {
        Group {
            if let title = item.title {
                Text("\(Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(Color(.label))) \(Text(item.body).font(.system(size: 15, weight: .regular)).foregroundColor(Color(.secondaryLabel)))")
            } else {
                Text(item.body)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
        .lineSpacing(3)
    }
}

// Section Footer

private struct SectionFooter: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(Color(.tertiaryLabel))
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

//  Preview

#Preview {
    NavigationStack {
        TestInstructionsView()
    }
}