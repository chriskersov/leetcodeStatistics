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
    
    enum Tab { case home, settings }
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Area
            Group {
                switch selectedTab {
                case .home:
                    HomeContentView(leetCodeStats: leetCodeStats)
                case .settings:
                    SettingsView()
                }
            }
            
            // Navigation Bar
            CustomNavBar(selectedTab: $selectedTab)
        }
    }
}

struct CustomNavBar: View {
    @Binding var selectedTab: MainView.Tab
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.backgroundColourThreeDark)
            
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
        .background(Color.backgroundColourTwoDark)
    }
}

struct NavButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(isSelected ? .fontColourWhite : .fontColourGrey)
                .overlay(
                    isSelected ? AnyView(
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.white)
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

