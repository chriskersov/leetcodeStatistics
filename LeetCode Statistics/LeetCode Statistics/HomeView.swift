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
                    
                    // Stats Overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Problem Solving")
                            .font(.leetcodeFont)
                            .foregroundColor(.leetcodeYellow)
                        
                        VStack(spacing: 16) {
                            // Total Problems
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.count ?? 0) / 3406")
                                    .font(.leetcodeFontStandard)
                                    .foregroundColor(.fontColourWhite)
                            }
                            
                            // Difficulty Breakdown
                            ForEach(["Easy", "Medium", "Hard"], id: \.self) { difficulty in
                                let solved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == difficulty })?.count ?? 0
                                let total = difficulty == "Easy" ? 846 : (difficulty == "Medium" ? 1775 : 785)
                                let progressValue = Double(solved) / Double(total)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(difficulty)
                                            .foregroundColor(difficultyColor(difficulty))
                                        Spacer()
                                        Text("\(solved)/\(total)")
                                            .foregroundColor(.fontColourGrey)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .frame(width: geometry.size.width, height: 6)
                                                .opacity(0.3)
                                                .foregroundColor(.fontColourGrey)
                                            
                                            Rectangle()
                                                .frame(width: geometry.size.width * CGFloat(progressValue), height: 6)
                                                .foregroundColor(difficultyColor(difficulty))
                                        }
                                        .cornerRadius(3)
                                    }
                                    .frame(height: 6)
                                }
                            }
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
