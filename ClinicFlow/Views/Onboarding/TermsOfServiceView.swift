import SwiftUI

struct TermsOfServiceView: View {
    
    @State private var navigateToNext = false
    
    let termsContent = [
        TermsSection(
            title: "1. Terms",
            content: "By accessing and using this application, you agree to comply with these Terms of Service. The application and services provided within this app are for personal or medical use only, and never prior notice."
        ),
        TermsSection(
            title: "2. Use License",
            content: "Permission is granted to use this application for personal, non-commercial purposes only. Under this license, you may not:\n\n• Use the application for any commercial purposes\n• Prior to by removing this application as derivative application\n• Permanently copyright or reproduce material\n• Remove or distribute this application materials without authorization\n\nThis license will automatically terminated if you violate any of these restrictions."
        ),
        TermsSection(
            title: "3. Privacy",
            content: "Your privacy is important to us. CareConnect collects only necessary personal health information in accordance with applicable privacy laws and regulations. We implement appropriate security measures to protect your data."
        ),
        TermsSection(
            title: "4. Limitations",
            content: "The provider and information provided in this application, CareConnect, shall not be held responsible for any consequential decisions made based on information provided within this application. Users are solely responsible for verifying all medical advice received."
        ),
        TermsSection(
            title: "5. Revisions and Errata",
            content: "The materials appearing in CareConnect application could include technical, typographical, or photographic errors. CareConnect does not warrant that any of the materials are accurate, complete, or current. CareConnect may make changes to the materials at any time without notice."
        ),
        TermsSection(
            title: "6. Links",
            content: "CareConnect has not reviewed all the sites linked to its application and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by CareConnect."
        ),
        TermsSection(
            title: "7. Governing Law",
            content: "These terms and conditions are governed by and construed in accordance with applicable laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location."
        )
    ]
    
    var body: some View {
        ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                
                // MARK: - Header
                HStack {
                    Text("Terms of Service")
                        .scalableFont(size: 18, weight: .bold)
                        .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.22))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 14)
                .background(Color(.systemBackground))
                
                Divider()
                
                // MARK: - Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(termsContent) { section in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(section.title)
                                    .scalableFont(size: 15, weight: .semibold)
                                    .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.22))
                                
                                Text(section.content)
                                    .scalableFont(size: 13, weight: .regular)
                                    .foregroundColor(Color(red: 0.40, green: 0.43, blue: 0.50))
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                Divider()
                
                // MARK: - Bottom Buttons
                HStack(spacing: 14) {
                    
                    // Decline Button
                    Button(action: {
                    }) {
                        Text("Decline")
                            .scalableFont(size: 16, weight: .semibold)
                            .foregroundColor(Color.brand)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.brand, lineWidth: 1.5)
                            )
                    }
                    
                    // Accept Button
                    Button(action: {
                        navigateToNext = true
                    }) {
                        Text("Accept")
                            .scalableFont(size: 16, weight: .semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.brand)
                            .cornerRadius(14)
                            .shadow(color: Color.brand.opacity(0.26), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 20)
                .background(Color(.systemBackground))
                
                // Navigation
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToNext) {
            ContentView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Terms Section Model
struct TermsSection: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

#Preview {
    TermsOfServiceView()
}