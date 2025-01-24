//
//  SettingsView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 24/01/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            
            Text("Settings")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.fontColourWhite)
        }
    }
}

#Preview {
    WelcomeView()
}
