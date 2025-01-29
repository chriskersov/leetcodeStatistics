//
//  SettingsView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 24/01/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // ... other settings ...
                
                Button(action: {
                    userManager.clearAllData()
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
