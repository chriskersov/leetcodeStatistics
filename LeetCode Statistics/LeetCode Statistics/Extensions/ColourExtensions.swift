//
//  ColorExtensions.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 10/04/2025.
//

import SwiftUI

// Environment key for dynamic colors
struct ThemeKey: EnvironmentKey {
    static let defaultValue = ThemeManager.shared
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// Extension on Color to add dynamic theme variants
extension Color {
    static func dynamicColor(dark: Color, light: Color) -> Color {
        return ThemeManager.shared.color(dark: dark, light: light)
    }
    
    // Dynamic theme colors
    static var backgroundColour: Color {
        dynamicColor(dark: backgroundColourDark, light: backgroundColourLight)
    }
    
    static var backgroundColourTwo: Color {
        dynamicColor(dark: backgroundColourTwoDark, light: backgroundColourTwoLight)
    }
    
    static var backgroundColourThree: Color {
        dynamicColor(dark: backgroundColourThreeDark, light: backgroundColourThreeLight)
    }
    
    static var fontColour: Color {
        dynamicColor(dark: fontColourWhite, light: fontColourBlack)
    }
    
    static var secondaryFontColour: Color {
        dynamicColor(dark: fontColourGrey, light: fontColourGreyLight)
    }
    
    static var easyBlueTwo: Color {
        dynamicColor(dark: easyBlueTwoDark, light: easyBlueTwoLight)
    }
    
    static var mediumYellowTwo: Color {
        dynamicColor(dark: mediumYellowTwoDark, light: mediumYellowTwoLight)
    }
    
    static var hardRedTwo: Color {
        dynamicColor(dark: hardRedTwoDark, light: hardRedTwoLight)
    }
    
    static var leetcodeGreenTwo: Color {
        dynamicColor(dark: leetcodeGreenTwoDark, light: leetcodeGreenTwoLight)
    }
}
