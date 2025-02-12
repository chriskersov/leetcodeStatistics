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
    @State private var showingWidgetInstructions = false
    @State private var showingFeatureRequest = false  // Keep this
    @State private var showingMailError = false      // Add this
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                // Light Mode Button
                settingsButton(title: "Light Mode",
                             textColor: .fontColourBlack,
                             backgroundColor: .backgroundColourTwoLight)
                
                Button(action: {
                    showingWidgetInstructions = true
                }) {
                    settingsButton(title: "How to Add Widgets",
                                 textColor: .fontColourWhite,
                                 backgroundColor: .backgroundColourTwoDark)
                }
                .fullScreenCover(isPresented: $showingWidgetInstructions) {
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
                                 textColor: .fontColourWhite,
                                 backgroundColor: .backgroundColourTwoDark)
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

                // In your SettingsView, replace the Rate App button with:
                Button(action: {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }) {
                    settingsButton(title: "Rate App",
                                  textColor: .fontColourWhite,
                                  backgroundColor: .backgroundColourTwoDark)
                }
                
                settingsButton(title: "Share",
                             textColor: .fontColourWhite,
                             backgroundColor: .backgroundColourTwoDark)
                
                Spacer()
                
                settingsButton(title: "Support Me",
                             textColor: .fontColourWhite,
                             backgroundColor: .backgroundColourTwoDark)
                
                Spacer()
                
                // Sign Out Button
                Button(action: {
                    userManager.clearAllData()
                }) {
                    settingsButton(title: "Sign Out",
                                  textColor: .hardRed,
                                  backgroundColor: .backgroundColourTwoDark,
                                  alignment: .center)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
    
    // Helper function to create consistent buttons
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
    }
}

#Preview {
    WelcomeView()
}
