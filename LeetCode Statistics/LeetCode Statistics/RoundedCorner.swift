//
//  RoundedCorner.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/01/2025.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Extension to make it easier to use
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
