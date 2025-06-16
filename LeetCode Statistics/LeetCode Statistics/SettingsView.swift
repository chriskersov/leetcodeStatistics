//
//  SettingsView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 24/01/2025.
//

import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showingWidgetInstructions = false
    @State private var showingFeatureRequest = false
    @State private var showingMailError = false
    @State private var showingShareSheet = false
    @State private var isLoading = false
    @State private var showingThankYou = false
    @State private var errorMessage = ""
    
    private let appURL = URL(string: "https://apps.apple.com/your-app-id")!
    private let shareMessage = "Check out LeetCode Statistics!"
    
    // Your product IDs - change to match your bundle ID
    private let donationProducts = [
        "com.chriskersov.leetcodestatistics.donation.small",   // £1.99
        "com.chriskersov.leetcodestatistics.donation.medium",  // £4.99
        "com.chriskersov.leetcodestatistics.donation.large"    // £8.99
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundColour
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Theme Toggle Button
                    Button(action: {
                        themeManager.toggleTheme()
                    }) {
                        settingsButton(
                            title: themeManager.currentTheme == .dark ? "Light Mode" : "Dark Mode",
                            textColor: themeManager.currentTheme == .dark ? .fontColourBlack : .fontColourWhite,
                            backgroundColor: themeManager.currentTheme == .dark ? .backgroundColourTwoLight : .backgroundColourTwoDark
                        )
                    }
                    
                    Button(action: {
                        showingWidgetInstructions = true
                    }) {
                        settingsButton(title: "How to Add Widgets",
                                     textColor: .fontColour,
                                     backgroundColor: .backgroundColourTwo)
                    }
                    .sheet(isPresented: $showingWidgetInstructions) {
                        AddWidgetsView()
                    }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showingFeatureRequest = true
                        } else {
                            showingMailError = true
                        }
                    }) {
                        settingsButton(title: "Feature Request",
                                     textColor: .fontColour,
                                     backgroundColor: .backgroundColourTwo)
                    }
                    .sheet(isPresented: $showingFeatureRequest) {
                        FeatureRequestView(isShowing: $showingFeatureRequest)
                    }
                    .alert("Cannot Send Email",
                           isPresented: $showingMailError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Your device is not configured to send emails. Please check your email settings.")
                    }

                    // Rate App button
                    Button(action: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }) {
                        settingsButton(title: "Rate App",
                                      textColor: .fontColour,
                                      backgroundColor: .backgroundColourTwo)
                    }
                    
                    Button(action: {
                         showingShareSheet = true
                     }) {
                         settingsButton(title: "Share",
                                      textColor: .fontColour,
                                      backgroundColor: .backgroundColourTwo)
                     }
                     .sheet(isPresented: $showingShareSheet) {
                         ShareSheet(activityItems: [shareMessage, appURL])
                     }
                    
                    // Support Section (replacing the old Support Me button)
                    VStack(spacing: 12) {
                        HStack {
                            Text("Support")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.fontColour)
                            Text("Chris")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.leetcodeYellow)
                            Spacer()
                        }
                        
                        HStack {
                            Text("If you would like to support me with a small donation, that would be greatly appreciated!")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.fontColour)
                            Spacer()
                        }
                        
                        // Donation buttons
                        VStack(spacing: 12) {
                            DonationButton(
                                isLoading: isLoading,
                                onSmallDonation: { buyDonation(productID: donationProducts[0]) },
                                onMediumDonation: { buyDonation(productID: donationProducts[1]) },
                                onLargeDonation: { buyDonation(productID: donationProducts[2]) }
                            )
                        }
                        
                        if isLoading {
                            ProgressView("Processing...")
                                .foregroundColor(.fontColour)
                                .padding()
                        }
                        
                        if !errorMessage.isEmpty {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.hardRed)
                                .font(.caption)
                                .padding()
                        }
                    }
                    .padding()
                    .background(Color.backgroundColourTwo)
                    .cornerRadius(5)
                    .shadow(
                        color: themeManager.color(
                            dark: Color.black.opacity(0.3),
                            light: Color.gray.opacity(0.2)
                        ),
                        radius: 5,
                        x: 0,
                        y: 2
                    )
                    
                    // Sign Out Button
                    Button(action: {
                        userManager.clearAllData()
                    }) {
                        settingsButton(title: "Sign Out",
                                      textColor: .hardRed,
                                      backgroundColor: .backgroundColourTwo,
                                      alignment: .center)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                .padding(.bottom, 60) // Add bottom padding for the custom nav bar
            }
        }
        .environment(\.themeManager, themeManager)
        .alert("Thank You!", isPresented: $showingThankYou) {
            Button("No Problem") { }
        } message: {
            Text("Your support is greatly appreciated!")
        }
    }
    
    // Purchase function
    func buyDonation(productID: String) {
        Task {
            isLoading = true
            errorMessage = ""
            
            do {
                // Get the product from App Store
                let products = try await Product.products(for: [productID])
                guard let product = products.first else {
                    errorMessage = "Product not found"
                    isLoading = false
                    return
                }
                
                // Try to purchase
                let result = try await product.purchase()
                
                switch result {
                case .success:
                    // Success! Show thank you
                    showingThankYou = true
                case .userCancelled:
                    // User cancelled, no problem
                    break
                case .pending:
                    errorMessage = "Purchase is pending"
                @unknown default:
                    errorMessage = "Unknown result"
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    // Helper function to create consistent buttons with shadow
    private func settingsButton(title: String, textColor: Color, backgroundColor: Color, alignment: HorizontalAlignment = .leading) -> some View {
        VStack(alignment: alignment) {
            HStack {
                if alignment == .center {
                    Spacer()
                }
                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(textColor)
                if alignment == .center {
                    Spacer()
                }
                if alignment == .leading {
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(backgroundColor)
        .cornerRadius(5)
        .shadow(
            color: themeManager.color(
                dark: Color.black.opacity(0.3),
                light: Color.gray.opacity(0.2)
            ),
            radius: 5,
            x: 0,
            y: 2
        )
    }
    
    struct ShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]
        let applicationActivities: [UIActivity]? = nil
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(
                activityItems: activityItems,
                applicationActivities: applicationActivities
            )
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }
}

// Updated Donation button component
struct DonationButton: View {
    @StateObject private var themeManager = ThemeManager.shared
    let isLoading: Bool
    let onSmallDonation: () -> Void
    let onMediumDonation: () -> Void
    let onLargeDonation: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: onSmallDonation) {
                Text("£1.99")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
            
            Spacer()
            
            Button(action: onMediumDonation) {
                Text("£4.99")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
            
            Spacer()
            
            Button(action: onLargeDonation) {
                Text("£9.99")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundColourThree)
        .cornerRadius(5)
        .opacity(isLoading ? 0.6 : 1.0)
    }
}

#Preview {
    SettingsView()
}
