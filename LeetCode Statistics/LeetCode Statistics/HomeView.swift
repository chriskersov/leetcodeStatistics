//
//  HomeView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/

import SwiftUI

struct HomeView: View {
    let leetCodeStats: LeetCodeResponse
    
    private var acceptanceRate: Double {
        let totalAccepted = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        let totalSubmissions = leetCodeStats.data.matchedUser.submitStats.totalSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        return totalSubmissions > 0 ? (Double(totalAccepted) / Double(totalSubmissions) * 100) : 0
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Profile Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text(leetCodeStats.data.matchedUser.username)
                            .font(.leetcodeFont)
                            .foregroundColor(.leetcodeYellow)
                            .padding(.bottom, 4)
                        
                        Text("Rank: #\(leetCodeStats.data.matchedUser.profile.ranking)")
                            .font(.system(.headline))
                            .foregroundColor(.fontColourWhite)
                        
                        Text("\(leetCodeStats.data.matchedUser.profile.reputation) reputation")
                            .font(.system(.subheadline))
                            .foregroundColor(.fontColourGrey)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.backgroundColourTwoDark)
                    .cornerRadius(5)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 24) {
                            // Left side: Progress Circle
                            ZStack {
                                let easySolved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Easy" })?.count ?? 0
                                let mediumSolved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Medium" })?.count ?? 0
                                let hardSolved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Hard" })?.count ?? 0
                                let totalSolved = easySolved + mediumSolved + hardSolved
                                
                                // Background circle
                                Circle()
                                    .stroke(Color.backgroundColourDark, lineWidth: 10)
                                    .frame(width: 120, height: 120)
                                
                                // Easy section
                                Circle()
                                    .trim(from: 0, to: Double(easySolved) / 846)
                                    .stroke(Color.easyBlue, style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                
                                // Medium section
                                Circle()
                                    .trim(from: Double(easySolved) / 846, to: Double(easySolved) / 846 + Double(mediumSolved) / 1775)
                                    .stroke(Color.mediumYellow, style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                
                                // Hard section
                                Circle()
                                    .trim(from: Double(easySolved) / 846 + Double(mediumSolved) / 1775,
                                          to: Double(easySolved) / 846 + Double(mediumSolved) / 1775 + Double(hardSolved) / 785)
                                    .stroke(Color.hardRed, style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                
                                // Center text
                                VStack(spacing: 2) {
                                    Text("\(totalSolved)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.fontColourWhite)
                                    Text("/3406")
                                        .font(.system(size: 14))
                                        .foregroundColor(.fontColourGrey)
                                }
                            }
                            
                            // Right side: Problem counts
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(["Easy", "Medium", "Hard"], id: \.self) { difficulty in
                                    let solved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == difficulty })?.count ?? 0
                                    let total = difficulty == "Easy" ? 846 : (difficulty == "Medium" ? 1775 : 785)
                                    
                                    HStack(spacing: 8) {
                                        Text("\(solved)/\(total)")
                                            .foregroundColor(.fontColourWhite)
                                            .font(.leetcodeFontStandard)
                                        
                                        Text(difficulty.lowercased())
                                            .foregroundColor(difficultyColor(difficulty))
                                            .font(.leetcodeFontStandard)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.backgroundColourTwoDark)
                    .cornerRadius(5)
                    
                    // Acceptance Rate Circle
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.backgroundColourTwoDark, lineWidth: 8)
                                .frame(width: 150, height: 150)
                            
                            Circle()
                                .trim(from: 0, to: acceptanceRate / 100)
                                .stroke(Color.leetcodeGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 4) {
                                Text(String(format: "%.2f%%", acceptanceRate))
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                                    .foregroundColor(.fontColourWhite)
                                
                                Text("Acceptance")
                                    .font(.system(size: 16))
                                    .foregroundColor(.fontColourWhite)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.backgroundColourTwoDark)
                    .cornerRadius(5)
                    
                    // Recent Submissions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Submissions")
                            .font(.leetcodeFont)
                            .foregroundColor(.leetcodeYellow)
                        
                        ForEach(leetCodeStats.data.recentAcSubmissionList, id: \.id) { submission in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(submission.title)
                                    .font(.system(.headline))
                                    .foregroundColor(.fontColourWhite)
                                HStack {
                                    Text(submission.langName)
                                        .font(.system(.subheadline))
                                    if let timestamp = Int(submission.timestamp) {
                                        Text("•")
                                        Text(Date(timeIntervalSince1970: TimeInterval(timestamp)), style: .date)
                                            .font(.system(.subheadline))
                                    }
                                }
                                .foregroundColor(.fontColourGrey)
                            }
                            .padding(.vertical, 8)
                            
                            if submission.id != leetCodeStats.data.recentAcSubmissionList.last?.id {
                                Divider()
                                    .background(Color.fontColourGrey.opacity(0.3))
                            }
                        }
                    }
                    .padding()
                    .background(Color.backgroundColourTwoDark)
                    .cornerRadius(5)
                }
                .padding()
            }
        }
        
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty {
        case "Easy":
            return .easyBlue
        case "Medium":
            return .mediumYellow
        case "Hard":
            return .hardRed
        default:
            return .fontColourGrey
        }
    }
}

#Preview {
    WelcomeView()
}
