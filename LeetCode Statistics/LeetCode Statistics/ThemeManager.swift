//
//  ThemeManager.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 10/04/2025.
//

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case dark
    case light
    
    var isDark: Bool {
        return self == .dark
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "app_theme")
        }
    }
    
    private init() {
        // Load saved theme or default to dark
        if let savedTheme = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme(rawValue: savedTheme) {
            currentTheme = theme
        } else {
            currentTheme = .dark
        }
    }
    
    func toggleTheme() {
        currentTheme = currentTheme == .dark ? .light : .dark
    }
    
    // Helper for getting dynamic colors based on current theme
    func color(dark: Color, light: Color) -> Color {
        return currentTheme == .dark ? dark : light
    }
}
