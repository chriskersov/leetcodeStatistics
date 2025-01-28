//
//  HomeView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/

import SwiftUI

struct HomeContentView: View {
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
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("\(leetCodeStats.data.matchedUser.username)")
                                    .font(.system(size: 22, weight: .heavy))
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
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 139, height: 139)
                            .padding()
                            .background(Color.backgroundColourTwoDark)
                            .cornerRadius(4)
                        }
                        
    //                    ---------------------
                        
//                        gonna do the heat map here
                        
                        VStack(alignment: .leading, spacing: 5) {
                            let userCalendar = leetCodeStats.data.matchedUser.userCalendar
                            let formatter: DateFormatter = {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMM d, yyyy"
                                return formatter
                            }()
                            
                            let totalSubmissions = userCalendar.dailySubmissions.values.reduce(0, +)
                            
                            // Total submissions header
                            HStack(alignment: .lastTextBaseline, spacing: 4) {
                                Text("\(totalSubmissions)")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(.fontColourWhite)
                                
                                Text("submissions in the past year")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.fontColourWhite)
                            }
                            .padding(.bottom, 10)
                            
                            // Stats section
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .lastTextBaseline, spacing: 4) {
                                    Text("Total Active Days: ")
                                        .foregroundColor(.fontColourGrey)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(userCalendar.totalActiveDays)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourWhite)
                                }
                                
                                HStack(alignment: .lastTextBaseline, spacing: 4) {
                                    Text("Streak: ")
                                        .foregroundColor(.fontColourGrey)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(userCalendar.streak)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.fontColourWhite)
                                }
                            }
                            .padding(.bottom, 10)

                            // Calculate days to look back based on current day of week
                            let calendar = Calendar.current
                            let today = Date()
                            let weekday = calendar.component(.weekday, from: today) // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
                                                        
                            let daysToLookBack: Int = {
                                switch weekday {
                                case 1: // Sunday
                                    return 113
                                case 2: // Monday
                                    return 114
                                case 3: // Tuesday
                                    return 115
                                case 4: // Wednesday
                                    return 116
                                case 5: // Thursday
                                    return 117
                                case 6: // Friday
                                    return 118
                                case 7: // Saturday
                                    return 119
                                default:
                                    return 119
                                }
                            }()

//                            let totalColumns = 17
//                            let totalRows = 7
//                            let totalGridSize = totalColumns * totalRows
//                            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: totalColumns)

                            // Get our submission data first
                            let heatmapData = (0..<daysToLookBack).compactMap { dayOffset -> (date: Date, count: Int)? in
                                guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
                                let timestamp = String(Int(floor(date.timeIntervalSince1970 / 86400) * 86400))
                                let count = userCalendar.dailySubmissions[timestamp] ?? 0
                                return (date: date, count: count)
                            }.sorted { $0.date < $1.date }

                            let totalColumns = 17
                            let totalRows = 7
                            let totalGridSize = totalColumns * totalRows
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: totalColumns)

                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(0..<totalGridSize, id: \.self) { index in
                                    let column = index % totalColumns
                                    let row = index / totalColumns
                                    let absoluteIndex = row + (column * totalRows)
                                    
                                    // Determine corner positions
                                    let isTopLeft = index == 0
                                    let isTopRight = column == totalColumns - 1 && row == 0
                                    let isBottomLeft = column == 0 && row == totalRows - 1
                                    let isBottomRight = index == totalGridSize - 1
                                    
                                    // Determine which corner to round
                                    let corners: UIRectCorner = {
                                        if isTopLeft {
                                            return .topLeft
                                        } else if isTopRight {
                                            return .topRight
                                        } else if isBottomLeft {
                                            return .bottomLeft
                                        } else if isBottomRight {
                                            return .bottomRight
                                        }
                                        return []
                                    }()
                                    
                                    if absoluteIndex < daysToLookBack {
                                        let submissionData = heatmapData[absoluteIndex]
                                        
                                        if submissionData.count == 0 {
                                            Rectangle()
                                                .foregroundColor(Color.backgroundColourThreeDark)
                                                .aspectRatio(1, contentMode: .fit)
                                                .cornerRadius(3)
                                                .cornerRadius(6, corners: corners)
                                        } else {
                                            let nonZeroSubmissions = heatmapData.map { $0.count }.filter { $0 > 0 }
                                            let maxSubmissions = nonZeroSubmissions.max() ?? 1
                                            let minSubmissions = nonZeroSubmissions.min() ?? 1
                                            
                                            let opacity: Double = {
                                                if maxSubmissions == minSubmissions {
                                                    return 1.0
                                                }
                                                let range = maxSubmissions - minSubmissions
                                                let position = submissionData.count - minSubmissions
                                                return 0.3 + (0.7 * (Double(position) / Double(range)))
                                            }()
                                            
                                            Rectangle()
                                                .foregroundColor(.leetcodeYellow.opacity(opacity))
                                                .aspectRatio(1, contentMode: .fit)
                                                .cornerRadius(3)
                                                .cornerRadius(6, corners: corners)
                                        }
                                    } else {
                                        Rectangle()
                                            .foregroundColor(Color.backgroundColourTwoDark)
                                            .aspectRatio(1, contentMode: .fit)
                                            .cornerRadius(3)
                                            .cornerRadius(6, corners: corners)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                            
//                            ForEach(heatmapData, id: \.date) { entry in
//                                Text("\(formatter.string(from: entry.date)): \(entry.count) submissions")
//                                    .foregroundColor(.fontColourWhite)
//                                    .font(.system(size: 14, weight: .medium))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
                        }
                        .frame(width: 330)
                        .padding()
                        .background(Color.backgroundColourTwoDark)
                        .cornerRadius(5)
                        
//                        --------------------------------
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recent AC")
                                .font(.system(size: 24, weight: .heavy))
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
                
//                ZStack(alignment: .top) {
//                    // Gray top border for the entire bar
//                    Rectangle()
//                        .frame(height: 2)
//                        .foregroundColor(.backgroundColourThreeDark)
//                    
//                    HStack {
//                        // Home Button
//                        Button(action: {
//                            currentView = .home
//                            // Navigate to HomeView
////                            leetCodeStats = leetCodeStats // Refresh home view if needed
//                        }) {
//                            Text("Home")
//                                .font(.system(size: 22, weight: .semibold))
//                                .foregroundColor(.fontColourWhite)
//                                .overlay(
//                                    Rectangle()
//                                        .frame(height: 3)
//                                        .foregroundColor(.white)
//                                        .offset(y: -14),
//                                    alignment: .top
//                                )
//                        }
//                        
//                        Spacer()
//                        
//                        // Settings Button
//                        Button(action: {
//                            currentView = .settings
//                            // Navigate to SettingsView
//                            // You'll need to handle this navigation state
//                        }) {
//                            Text("Settings")
//                                .font(.system(size: 22, weight: .semibold))
//                                .foregroundColor(.fontColourGrey)
//                        }
//                    }
//                    .padding(.horizontal, 60)
//                    .padding(.top, 15)
//                    .frame(height: 40)
//                }
//                .background(Color.backgroundColourTwoDark)
//                .edgesIgnoringSafeArea(.bottom)
                
            }
            .frame(maxHeight: .infinity)
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
