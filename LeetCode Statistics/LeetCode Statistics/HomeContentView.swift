//
//  HomeView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/

import SwiftUI

struct HomeContentView: View {
    let leetCodeStats: LeetCodeResponse
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var acceptanceRate: Double {
        let totalAccepted = leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        let totalSubmissions = leetCodeStats.data.matchedUser.submitStats.totalSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
        return totalSubmissions > 0 ? (Double(totalAccepted) / Double(totalSubmissions) * 100) : 0
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColour
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(leetCodeStats.data.matchedUser.profile.realName ?? "")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(Color.fontColour)
                                
                                Text(leetCodeStats.data.matchedUser.username)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.secondaryFontColour)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack{
                                        Text("Rank:")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.secondaryFontColour)
                                        Text("\(leetCodeStats.data.matchedUser.profile.ranking)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.fontColour)
                                    }
                                    
                                    HStack{
                                        Text("Reputation:")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.secondaryFontColour)
                                        Text("\(leetCodeStats.data.matchedUser.profile.reputation)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.fontColour)
                                    }
                                    
                                    HStack{
                                        Text("Views:")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.secondaryFontColour)
                                        Text("\(leetCodeStats.data.matchedUser.profile.postViewCount)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.fontColour)
                                    }
                                }
                                
                            }
                            .frame(width: 143, height: 143, alignment: .topLeading)
                            .padding()
                            .background(Color.backgroundColourTwo)
                            .cornerRadius(4)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .center, spacing: 24) {
                                    // Circular Progress with Stats
                                    ZStack {
                                        // Background Circle (darker)
                                        Circle()
                                            .stroke(Color.backgroundColourTwo, lineWidth: 8)
                                            .frame(width: 143, height: 143)
                                        
                                        // Easy background
                                        Circle()
                                            .trim(from: 0.264, to: 0.569)
                                            .stroke(Color.easyBlueTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 143, height: 143)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Easy progress
                                        Circle()
                                            .trim(from: 0.264, to: 0.264 + (0.569 - 0.264) * (CGFloat(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Easy" })?.count ?? 0) / 846.0))
                                            .stroke(Color.easyBlue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 143, height: 143)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Medium background
                                        Circle()
                                            .trim(from: 0.597, to: 0.903)
                                            .stroke(Color.mediumYellowTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 143, height: 143)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Medium progress
                                        Circle()
                                            .trim(from: 0.597, to: 0.597 + (0.903 - 0.597) * (CGFloat(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "Medium" })?.count ?? 0) / 1775.0))
                                            .stroke(Color.mediumYellow, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            .frame(width: 143, height: 143)
                                            .rotationEffect(.degrees(0))
                                        
                                        // Hard background (split into two parts)
                                        Group {
                                            Circle()
                                                .trim(from: 0.931, to: 1.0)
                                                .stroke(Color.hardRedTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                                .frame(width: 143, height: 143)
                                                .rotationEffect(.degrees(0))
                                            
                                            Circle()
                                                .trim(from: 0.0, to: 0.236)
                                                .stroke(Color.hardRedTwo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                                .frame(width: 143, height: 143)
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
                                        .frame(width: 143, height: 143)
                                        .rotationEffect(.degrees(0))
                                        
                                        // Center Stats
                                        VStack(spacing: 2) {
                                            HStack(alignment: .lastTextBaseline) {
                                                Text("\(leetCodeStats.data.matchedUser.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.count ?? 0)")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(Color.fontColour)
                                                
                                                Text("/3415")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(Color.fontColour)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.leetcodeGreen)
                                                
                                                Text("Solved")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color.fontColour)
                                            }
                                            .padding(.top, 2)
                                            
//                                            Text("\(leetCodeStats.data.matchedUser.profile.attempting) Attempting")
//                                                .font(.system(size: 14))
//                                                .foregroundColor(Color.secondaryFontColour)
//                                                .padding(.top, 1)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.backgroundColourTwo)
                            .cornerRadius(4)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        
                        HStack{
                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.leetcodeGreenTwo, lineWidth: 8)
                                        .frame(width: 143, height: 143)
                                    
                                    Circle()
                                        .trim(from: 0, to: acceptanceRate / 100)
                                        .stroke(Color.leetcodeGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                        .frame(width: 143, height: 143)
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack(spacing: 4) {
                                        Text(String(format: "%.2f%%", acceptanceRate))
                                            .font(.system(size: 24, weight: .heavy))
                                            .foregroundColor(Color.fontColour)
                                        
                                        Text("Acceptance")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.fontColour)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.backgroundColourTwo)
                            .cornerRadius(4)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            
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
                                                .fill(Color.backgroundColourThree)
                                                .frame(width: 148, height: 43)
                                                .cornerRadius(3)
                                            
                                            // Content
                                            VStack(spacing: 2) {
                                                Text(difficulty == "Medium" ? "Medium" : difficulty)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(difficultyColor(difficulty))
                                                
                                                Text("\(solved)/\(total)")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(Color.fontColour)
                                            }
                                            
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 143, height: 143)
                            .padding()
                            .background(Color.backgroundColourTwo)
                            .cornerRadius(4)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            let userCalendar = leetCodeStats.data.matchedUser.userCalendar
                            
                            let totalSubmissions = userCalendar.dailySubmissions.values.reduce(0, +)
                            
                            // Total submissions header
                            HStack(alignment: .lastTextBaseline, spacing: 4) {
                                Text("\(totalSubmissions)")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(Color.fontColour)
                                
                                Text("submissions in the past year")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.fontColour)
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
                                                .foregroundColor(Color.backgroundColourThree)
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
                                            .foregroundColor(Color.backgroundColourTwo)
                                            .aspectRatio(1, contentMode: .fit)
                                            .cornerRadius(3)
                                            .cornerRadius(6, corners: corners)
                                    }
                                }
                            }
                            .padding(.bottom, 7)
                        }
                        .frame(width: 337)
                        .padding()
                        .background(Color.backgroundColourTwo)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recent AC")
                                .font(.system(size: 20, weight: .heavy))
                                .padding(.bottom, 10)
                                .foregroundColor(Color.fontColour)
                            
                            ForEach(Array(leetCodeStats.data.recentAcSubmissionList.enumerated()), id: \.element.id) { index, submission in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(submission.title)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color.fontColour)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Left alignment fix
                                    
                                    HStack {
                                        if let timestamp = Int(submission.timestamp) {
                                            Text(Date(timeIntervalSince1970: TimeInterval(timestamp)), style: .date)
                                                .font(.system(.subheadline))
                                                .frame(maxWidth: .infinity, alignment: .leading) // Left alignment fix
                                        }
                                    }
                                    .foregroundColor(Color.secondaryFontColour)
                                }
                                .frame(width: 322)
                                .padding(8)
                                .background(index % 2 == 0 ? Color.backgroundColourThree : Color.backgroundColourTwo) // Alternating colors
                                .cornerRadius(4)
                            }
                        }
                        .frame(width: 337)
                        .padding()
                        .background(Color.backgroundColourTwo)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding()
                }
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



//// This extension is needed for rounded corners
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}

#Preview {
    WelcomeView()
}
