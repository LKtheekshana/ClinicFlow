import SwiftUI

struct OTPVerificationView: View {
    var fullName: String = ""
    var mobileNumber: String = ""

    @State private var otpCode: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @FocusState private var isInputFocused: Bool
    @State private var navigateToLocationPermission = false
    
    @Environment(\.dismiss) private var dismiss

    private var otpDigits: [String] {
        let chars = Array(otpCode.prefix(6))
        return (0..<6).map { i in i < chars.count ? String(chars[i]) : "" }
    }

    private var activeIndex: Int {
        min(otpDigits.filter { !$0.isEmpty }.count, 6)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: max(geometry.safeAreaInsets.top + 20, 40))

                        ZStack {
                            Circle()
                                .fill(Color.brand.opacity(0.08))
                                .frame(width: 126, height: 126)

                            Circle()
                                .stroke(Color.brand, style: StrokeStyle(lineWidth: 2, dash: [3]))
                                .frame(width: 102, height: 102)

                            Circle()
                                .fill(Color.brand)
                                .frame(width: 54, height: 54)

                            Image(systemName: "message.fill")
                                .scalableFont(size: 24, weight: .bold)
                                .foregroundStyle(.white)
                                .overlay {
                                    Text("SMS")
                                        .scalableFont(size: 10, weight: .bold)
                                        .foregroundColor(.white)
                                        .offset(y: 11)
                                }
                        }

                        Text("Verify Your Number")
                            .scalableFont(size: 23, weight: .bold)
                            .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.23))
                            .padding(.top, 28)

                        Text("We sent a 6-digit OTP to")
                            .scalableFont(size: 16)
                            .foregroundColor(Color(red: 0.60, green: 0.61, blue: 0.71))
                            .padding(.top, 12)

                        Text("+94 \(mobileNumber)")
                            .scalableFont(size: 18, weight: .medium)
                            .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.23))
                            .padding(.top, 6)

                        HStack(spacing: 6) {
                            Text("Wrong number?")
                                .scalableFont(size: 15)
                                .foregroundColor(Color(red: 0.60, green: 0.61, blue: 0.71))

                            Button("Change") {
                                dismiss()
                            }
                            .scalableFont(size: 15, weight: .medium)
                            .foregroundColor(.brand)
                        }
                        .padding(.top, 8)

                        ZStack {
                            TextField("", text: $otpCode)
                                .keyboardType(.numberPad)
                                .focused($isInputFocused)
                                .opacity(0)
                                .frame(width: 1, height: 1)
                                .onChange(of: otpCode) { newValue in
                                    otpCode = String(newValue.filter(\.isNumber).prefix(6))
                                }

                            HStack(spacing: 10) {
                                ForEach(0..<6, id: \.self) { index in
                                    OTPDigitBox(
                                        value: otpDigits[index],
                                        isActive: isInputFocused && index == activeIndex,
                                        isEmpty: otpDigits[index].isEmpty
                                    )
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isInputFocused = true
                        }
                        .padding(.top, 34)
                        .padding(.horizontal, 18)

                        Text("Didn't receive the code?")
                            .scalableFont(size: 14)
                            .foregroundColor(Color(red: 0.60, green: 0.61, blue: 0.71))
                            .padding(.top, 30)

                        HStack(spacing: 10) {
                            Image(systemName: "clock.fill")
                                .scalableFont(size: 14, weight: .medium)

                            Text("Resend OTP in 0:45")
                                .scalableFont(size: 14, weight: .medium)
                        }
                        .foregroundColor(.brand)
                        .padding(.horizontal, 22)
                        .frame(height: 40)
                        .background(Color.brand.opacity(0.08))
                        .clipShape(Capsule())
                        .padding(.top, 16)

                        Button {
                            validateOTPAndProceed()
                        } label: {
                            HStack(spacing: 10) {
                                Text("Verify OTP")
                                    .scalableFont(size: 16, weight: .semibold)

                                Image(systemName: "checkmark")
                                    .scalableFont(size: 14, weight: .bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.brand)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.brand.opacity(0.25), radius: 9, x: 0, y: 6)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 42)

                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .scalableFont(size: 12, weight: .semibold)

                            Text("Your information is secure and encrypted")
                                .scalableFont(size: 13)
                        }
                        .foregroundColor(Color(red: 0.60, green: 0.61, blue: 0.71))
                        .padding(.top, 24)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 18, 28))

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToLocationPermission) {
            LocationPermissionPromptView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .alert("OTP Verification", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func validateOTPAndProceed() {
        // Reset error state
        showError = false
        errorMessage = ""
        
        // Validate OTP code
        let trimmedOTP = otpCode.trimmingCharacters(in: .whitespaces)
        if trimmedOTP.isEmpty {
            showError = true
            errorMessage = "Please enter the OTP"
            return
        }
        
        if trimmedOTP.count != 6 {
            showError = true
            errorMessage = "OTP must be 6 digits"
            return
        }
        
        let otpDigitsOnly = trimmedOTP.filter { $0.isNumber }
        if otpDigitsOnly.count != 6 {
            showError = true
            errorMessage = "OTP must contain only numbers"
            return
        }
        
        // All validations passed
        navigateToLocationPermission = true
    }
}

private struct OTPDigitBox: View {
    let value: String
    let isActive: Bool
    let isEmpty: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(isEmpty ? Color.gray.opacity(0.08) : Color.white.opacity(0.65))

            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isActive ? Color.brand : Color.brand.opacity(isEmpty ? 0.10 : 0.95),
                    lineWidth: isActive ? 2.4 : 1.4
                )

            if isActive {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.brand)
                    .frame(width: 2, height: 28)
            } else {
                Text(value)
                    .scalableFont(size: 38 / 2, weight: .medium)
                    .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.23))
            }
        }
        .frame(width: 50, height: 62)
    }
}

#Preview {
    OTPVerificationView()
}
