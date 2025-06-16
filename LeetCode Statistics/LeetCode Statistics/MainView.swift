//
//  MainView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 24/01/2025.
//

import SwiftUI

struct MainView: View {
    let leetCodeStats: LeetCodeResponse
    @State private var selectedTab: Tab = .home
    @StateObject private var userManager = UserManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    // Timer for periodic updates
    let timer = Timer.publish(every: 3600, on: .main, in: .common).autoconnect()
    
    enum Tab { case home, settings }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home:
                    HomeContentView(leetCodeStats: leetCodeStats)
                        .environmentObject(themeManager)
                case .settings:
                    SettingsView()
                        .environmentObject(themeManager)
                }
            }
            
            CustomNavBar(selectedTab: $selectedTab)
                .environmentObject(themeManager)
        }
        .onReceive(timer) { _ in
            // Refresh stats every hour while the app is open - might not need this icl
//            could be done via background refresh when we do widget
            if let username = userManager.currentUsername {
                Task {
                    await userManager.refreshStats(for: username)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Refresh stats whenever app comes to foreground
            if let username = userManager.currentUsername {
                Task {
                    await userManager.refreshStats(for: username)
                }
            }
        }
    }
}

struct CustomNavBar: View {
    @Binding var selectedTab: MainView.Tab
    @EnvironmentObject private var themeManager: ThemeManager  // Add this line
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.backgroundColourThree)
            
            HStack {
                NavButton(
                    title: "Home",
                    isSelected: selectedTab == .home,
                    action: { selectedTab = .home }
                )
                
                Spacer()
                
                NavButton(
                    title: "Settings",
                    isSelected: selectedTab == .settings,
                    action: { selectedTab = .settings }
                )
            }
            .padding(.horizontal, 60)
            .padding(.top, 15)
            .frame(height: 40)
        }
        .background(Color.backgroundColourTwo)
    }
}

struct NavButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager  // Add this line
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(isSelected ? Color.fontColour : Color.secondaryFontColour)
                .overlay(
                    isSelected ? AnyView(
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(Color.fontColour)
                            .offset(y: -14)
                    ) : AnyView(EmptyView()),
                    alignment: .top
                )
                .contentShape(Rectangle()) // Ensure the entire area is tappable
        }
        .onTapGesture {
            action() // Perform the action instantly
        }
    }
}

#Preview {
    WelcomeView()
}

