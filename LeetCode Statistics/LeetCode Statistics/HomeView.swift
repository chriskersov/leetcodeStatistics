//
//  HomeView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/

import SwiftUI

struct HomeView: View {
    let leetCodeStats: LeetCodeResponse
    
    @State private var profileImage: UIImage?

    private func loadProfileImage() async {
        profileImage = try? await URLSession.shared.fetchProfileImage(username: leetCodeStats.data.matchedUser.username)
    }
    
    private var acceptanceRate: Double {
        let totalAccepted = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        let totalSubmissions = leetCodeStats.data.matchedUser.submitStats.totalSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        return totalSubmissions > 0 ? (Double(totalAccepted) / Double(totalSubmissions) * 100) : 0
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
    //                    // Profile Card
    //                    VStack(alignment: .leading, spacing: 8) {
    //                        Text(leetCodeStats.data.matchedUser.username)
    //                            .font(.leetcodeFont)
    //                            .foregroundColor(.leetcodeYellow)
    //                            .padding(.bottom, 4)
    //
    //                        Text("Rank: #\(leetCodeStats.data.matchedUser.profile.ranking)")
    //                            .font(.system(.headline))
    //                            .foregroundColor(.fontColourWhite)
    //
    //                        Text("\(leetCodeStats.data.matchedUser.profile.reputation) reputation")
    //                            .font(.system(.subheadline))
    //                            .foregroundColor(.fontColourGrey)
    //                    }
    //                    .frame(maxWidth: .infinity, alignment: .leading)
    //                    .padding()
    //                    .background(Color.backgroundColourTwoDark)
    //                    .cornerRadius(5)
                        

                        

                        
                        HStack{
                            // Acceptance Rate Circle
                            // Acceptance Rate Circle
                            VStack(alignment: .leading) {
                                
    //                            if let image = profileImage {
    //                                Image(uiImage: image)
    //                                    .resizable()
    //                                    .scaledToFill()
    //                                    .frame(width: 40, height: 40)
    //                                    .clipShape(Circle())
    //                            } else {
    //                                Circle()
    //                                    .fill(Color.backgroundColourThreeDark)
    //                                    .frame(width: 40, height: 40)
    //                            }
    //
                                Text("\(leetCodeStats.data.matchedUser.username)")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(.fontColourWhite)
        
                                Spacer()
                                
                                HStack{
                                    Text("Rank:")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourGrey)
                                    Text("\(leetCodeStats.data.matchedUser.profile.ranking)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourWhite)
                                }
                                
                                HStack{
                                    Text("Reputation:")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourGrey)
                                    Text("\(leetCodeStats.data.matchedUser.profile.reputation)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourWhite)
                                }
                            }
                            .frame(width: 139, height: 139)
                            .padding()
                            .background(Color.backgroundColourTwoDark)
                            .cornerRadius(4)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .center, spacing: 24) {
                                    // Circular Progress with Stats
                                    ZStack {
                                        // Background Circle (darker)
                                        Circle()
                                            .stroke(Color.backgroundColourTwoDark, lineWidth: 8)
                                            .frame(width: 139, height: 139)
                                        
                                        // Easy background
                                        Circle()
                                            .trim(from: 0.264, to: 0.569)
                                            .stroke(Color.easyBlueTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 139, height: 139)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Easy progress
                                        Circle()
                                            .trim(from: 0.264, to: 0.264 + (0.569 - 0.264) * (CGFloat(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Easy" })?.count ?? 0) / 846.0))
                                            .stroke(Color.easyBlue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 139, height: 139)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Medium background
                                        Circle()
                                            .trim(from: 0.597, to: 0.903)
                                            .stroke(Color.mediumYellowTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 139, height: 139)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Medium progress
                                        Circle()
                                            .trim(from: 0.597, to: 0.597 + (0.903 - 0.597) * (CGFloat(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Medium" })?.count ?? 0) / 1775.0))
                                            .stroke(Color.mediumYellow, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 139, height: 139)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Hard background (split into two parts)
                                        Group {
                                            Circle()
                                                .trim(from: 0.931, to: 1.0)
                                                .stroke(Color.hardRedTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                                .frame(width: 139, height: 139)
                                                .rotationEffect(.degrees(0))
                                            
                                            Circle()
                                                .trim(from: 0.0, to: 0.236)
                                                .stroke(Color.hardRedTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                                .frame(width: 139, height: 139)
                                                .rotationEffect(.degrees(0))
                                        }
                                        
                                        // Hard progress
                                        let hardSolved = CGFloat(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Hard" })?.count ?? 0)
                                        let hardTotal: CGFloat = 785.0
                                        let hardProgress = hardSolved / hardTotal
                                        let hardTotalLength = (1.0 - 0.931) + 0.236  // Total arc length
                                        let hardProgressLength = hardTotalLength * hardProgress
                                        
                                        Group {
                                            if hardProgressLength <= (1.0 - 0.931) {
                                                // Progress fits before 1.0
                                                Circle()
                                                    .trim(from: 0.931, to: 0.931 + hardProgressLength)
                                                    .stroke(Color.hardRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            } else {
                                                // Progress needs to wrap around
                                                Circle()
                                                    .trim(from: 0.931, to: 1.0)
                                                    .stroke(Color.hardRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                                
                                                Circle()
                                                    .trim(from: 0.0, to: hardProgressLength - (1.0 - 0.931))
                                                    .stroke(Color.hardRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            }
                                        }
                                        .frame(width: 139, height: 139)
                                        .rotationEffect(.degrees(0))
                                        
                                        // Center Stats
                                        VStack(spacing: 2) {
                                            HStack(alignment: .lastTextBaseline) {
                                                Text("\(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.count ?? 0)")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.fontColourWhite)
                                                
                                                Text("/3415")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.fontColourWhite)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.leetcodeGreen)
                                                
                                                Text("Solved")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.fontColourWhite)
                                            }
                                            .padding(.top, 2)
                                            
                                            Text("1 Attempting")
                                                .font(.system(size: 14))
                                                .foregroundColor(.fontColourGrey)
                                                .padding(.top, 1)
                                        }
                                    }
                                    

                                }
    //                            .frame(maxWidth: .infinity, alignment: .center)
    //                            .padding(.vertical, 10)
                            }
                            .padding()
                            .background(Color.backgroundColourTwoDark)
                            .cornerRadius(4)
                            
                        }
                        
    //                    ----------------------
                        
                        HStack{

                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.leetcodeGreenTwo, lineWidth: 8)
                                        .frame(width: 139, height: 139)
                                    
                                    Circle()
                                        .trim(from: 0, to: acceptanceRate / 100)
                                        .stroke(Color.leetcodeGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                        .frame(width: 139, height: 139)
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack(spacing: 4) {
                                        Text(String(format: "%.2f%%", acceptanceRate))
                                            .font(.system(size: 24, weight: .heavy))
                                            .foregroundColor(.fontColourWhite)
                                        
                                        Text("Acceptance")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.fontColourWhite)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.backgroundColourTwoDark)
                            .cornerRadius(4)
                            
                            Spacer()
                            
                            ZStack() {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Spacer()
                                    
                                    // Difficulty stats in vertical layout
                                    ForEach(["Easy", "Medium", "Hard"], id: \.self) { difficulty in
                                        let solved = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == difficulty })?.count ?? 0
                                        let total = difficulty == "Easy" ? 846 : (difficulty == "Medium" ? 1775 : 785)
                                        
                                        ZStack {
                                            // Background rectangle with fixed size
                                            Rectangle()
                                                .fill(Color.backgroundColourThreeDark)
                                                .frame(width: 148, height: 43)
                                                .cornerRadius(3)
                                            
                                            // Content
                                            VStack(spacing: 2) {
                                                Text(difficulty == "Medium" ? "Medium" : difficulty)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(difficultyColor(difficulty))
                                                
                                                Text("\(solved)/\(total)")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.fontColourWhite)
                                            }
    //                                        .padding(.horizontal, 8)
                                        }
                                    }
                                    
                                    Spacer()
                                }
    //                            .frame(height: 139)
                                
                            }
                            .frame(width: 139, height: 139)
                            .padding()
                            .background(Color.backgroundColourTwoDark)
                            .cornerRadius(4)
                            
                        }
                        
    //                    ---------------------
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recent AC")
                                .font(.system(size: 22, weight: .heavy))
                                .padding(.bottom, 10)
                                .foregroundColor(.fontColourWhite)
                            
                            ForEach(Array(leetCodeStats.data.recentAcSubmissionList.enumerated()), id: \.element.id) { index, submission in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(submission.title)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourWhite)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Left alignment fix
                                    
                                    HStack {
                                        if let timestamp = Int(submission.timestamp) {
                                            Text(Date(timeIntervalSince1970: TimeInterval(timestamp)), style: .date)
                                                .font(.system(.subheadline))
                                                .frame(maxWidth: .infinity, alignment: .leading) // Left alignment fix
                                        }
                                    }
                                    .foregroundColor(.fontColourGrey)
                                }
                                .frame(width: 322)
                                .padding(8)
                                .background(index % 2 == 0 ? Color.backgroundColourThreeDark : Color.backgroundColourTwoDark) // Alternating colors
                                .cornerRadius(4)
                            }
                        }
                        .frame(width: 330)
                        .padding()
                        .background(Color.backgroundColourTwoDark)
                        .cornerRadius(5)
                        
    //                    ---------------------------
                       
                        
                    }
                    .padding()
                    
                }
                
                ZStack(alignment: .top) {
                    // Gray top border for the entire bar
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.backgroundColourThreeDark)
                    
                    HStack {
                        Text("  ")
                        Text("Home")
                            .font(.system(size: 22, weight: .semibold))
//                            .padding(.horizontal, 8)
                            .foregroundColor(.fontColourWhite)
                            .overlay(
                                Rectangle()
                                    .frame(height: 3)  // White indicator thickness
                                    .foregroundColor(.white)
                                    .offset(y: -14),  // Position above text
                                alignment: .top
                            )
                        Text("  ")
                        
                        Spacer()
                        
                        Text("Settings")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.fontColourGrey)
//                            .overlay(
//                                Rectangle()
//                                    .frame(height: 3)  // White indicator thickness
//                                    .foregroundColor(.white)
//                                    .offset(y: -14),  // Position above text
//                                alignment: .top
//                            )
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 15)
                    .frame(height: 40)
                }
                .background(Color.backgroundColourTwoDark)
                .edgesIgnoringSafeArea(.bottom)
                
            }
            .frame(maxHeight: .infinity)
            
        }
        .onAppear {
            Task {
                await loadProfileImage()
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
