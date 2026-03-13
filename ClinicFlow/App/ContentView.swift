//
//  ContentView.swift
//  ClinicApp
//
//  Created by COBSCCOMP242P-031 on 2026-02-25.
//

import SwiftUI

struct ContentView: View {
    @State private var fullName: String = ""
    @State private var mobileNumber: String = ""
    @State private var navigateToOTP = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.brand)
                                    .frame(width: 64, height: 64)

                                Image(systemName: "cross.case.fill")
                                    .scalableFont(size: 28, weight: .bold)
                                    .foregroundColor(.white)
                            }

                            Text("CareConnect")
                                .scalableFont(size: 21, weight: .bold)
                                .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))

                            Text("Your Health, Our Priority")
                                .scalableFont(size: 16)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, max(geometry.safeAreaInsets.top + 20, 34))

                        Text("Welcome Back 👋")
                            .scalableFont(size: 22, weight: .bold)
                            .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))
                            .padding(.top, 38)

                        Text("Enter your details to continue")
                            .scalableFont(size: 15)
                            .foregroundColor(.gray)
                            .padding(.top, 8)

                        Text("Full Name")
                            .scalableFont(size: 14, weight: .semibold)
                            .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))
                            .padding(.top, 28)

                        TextField("Enter your full name", text: $fullName)
                            .scalableFont(size: 17)
                            .padding(.horizontal, 18)
                            .frame(height: 60)
                            .background(Color.white.opacity(0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .cornerRadius(16)
                            .padding(.top, 12)

                        Text("Mobile Number")
                            .scalableFont(size: 14, weight: .semibold)
                            .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))
                            .padding(.top, 28)

                        HStack(spacing: 12) {
                            Text("🇱🇰 +94")
                                .scalableFont(size: 15, weight: .medium)
                                .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))

                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 1, height: 24)

                            TextField("XX XXX XXXX", text: $mobileNumber)
                                .keyboardType(.numberPad)
                                .scalableFont(size: 17)
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 60)
                        .background(Color.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(16)
                        .padding(.top, 12)

                        Button {
                            validateAndProceed()
                        } label: {
                            HStack(spacing: 12) {
                                Text("Send OTP")
                                    .scalableFont(size: 15, weight: .bold)
                                Image(systemName: "arrow.right")
                                    .scalableFont(size: 15, weight: .bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.brand)
                            .cornerRadius(16)
                            .shadow(color: Color.brand.opacity(0.25), radius: 9, x: 0, y: 6)
                        }
                        .padding(.top, 30)

                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 1)

                            Text("or continue with")
                                .scalableFont(size: 14)
                                .foregroundColor(.gray)

                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 1)
                        }
                        .padding(.top, 34)

                        HStack(spacing: 14) {
                            SocialButton(icon: "G", title: "Google")
                            SocialButton(icon: "", title: "Apple")
                        }
                        .padding(.top, 18)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 22, 28))
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToOTP) {
            OTPVerificationView(fullName: fullName, mobileNumber: mobileNumber)
                .toolbar(.hidden, for: .navigationBar)
        }
        .alert("Validation Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func validateAndProceed() {
        // Reset error state
        showError = false
        errorMessage = ""
        
        // Validate full name
        let trimmedName = fullName.trimmingCharacters(in: .whitespaces)
        if trimmedName.isEmpty {
            showError = true
            errorMessage = "Please enter your full name"
            return
        }
        
        if trimmedName.count < 3 {
            showError = true
            errorMessage = "Name must be at least 3 characters"
            return
        }
        
        // Validate mobile number
        let trimmedMobile = mobileNumber.trimmingCharacters(in: .whitespaces)
        if trimmedMobile.isEmpty {
            showError = true
            errorMessage = "Please enter your mobile number"
            return
        }
        
        let mobileDigits = trimmedMobile.filter { $0.isNumber }
        if mobileDigits.count != 9 && mobileDigits.count != 10 {
            showError = true
            errorMessage = "Please enter a valid mobile number (9-10 digits)"
            return
        }
        
        // All validations passed
        navigateToOTP = true
    }
}

private struct SocialButton: View {
    let icon: String
    let title: String

    var body: some View {
        Button {
        } label: {
            HStack(spacing: 10) {
                Text(icon)
                    .scalableFont(size: 14, weight: .bold)
                    .foregroundColor(title == "Google" ? .red : Color(red: 0.12, green: 0.13, blue: 0.24))

                Text(title)
                    .scalableFont(size: 15, weight: .semibold)
                    .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.24))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(Color.white.opacity(0.65))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(15)
        }
    }
}

#Preview {
    ContentView()
}
