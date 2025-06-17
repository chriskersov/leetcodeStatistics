import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct LeetCodeEntry: TimelineEntry {
    let date: Date
    let heatmapData: [(date: Date, count: Int)]
    let totalSubmissions: Int
    let userName: String?
}

// MARK: - Timeline Provider
struct LeetCodeProvider: TimelineProvider {
    typealias Entry = LeetCodeEntry
    
    func placeholder(in context: Context) -> LeetCodeEntry {
        LeetCodeEntry(
            date: Date(),
            heatmapData: generatePlaceholderData(),
            totalSubmissions: 247,
            userName: "username"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (LeetCodeEntry) -> ()) {
        let entry = LeetCodeEntry(
            date: Date(),
            heatmapData: generatePlaceholderData(),
            totalSubmissions: 247,
            userName: "username"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchLeetCodeData { heatmapData, totalSubmissions, userName in
            let currentDate = Date()
            let entry = LeetCodeEntry(
                date: currentDate,
                heatmapData: heatmapData,
                totalSubmissions: totalSubmissions,
                userName: userName
            )
            
            // Update every 30 minutes
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    private func generatePlaceholderData() -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = Date()
        
        // Calculate days to look back based on current day of week (matching HomeContentView)
        let weekday = calendar.component(.weekday, from: today)
        let daysToLookBack: Int = {
            switch weekday {
            case 1: return 113 // Sunday
            case 2: return 114 // Monday
            case 3: return 115 // Tuesday
            case 4: return 116 // Wednesday
            case 5: return 117 // Thursday
            case 6: return 118 // Friday
            case 7: return 119 // Saturday
            default: return 119
            }
        }()
        
        return (0..<daysToLookBack).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            let count = Int.random(in: 0...5)
            return (date: date, count: count)
        }.sorted { $0.date < $1.date }
    }
    
    private func fetchLeetCodeData(completion: @escaping ([(date: Date, count: Int)], Int, String?) -> Void) {
        print("🔍 Widget: Starting to fetch LeetCode data")
        
        // Get shared data from your main app using App Groups
        let sharedDefaults = UserDefaults(suiteName: "group.com.chriskersov.leetcodestatistics")
        
        print("🔍 Widget: SharedDefaults created: \(sharedDefaults != nil)")
        
        if let data = sharedDefaults?.data(forKey: "leetcode_data") {
            print("✅ Widget: Found data in UserDefaults, size: \(data.count) bytes")
            
            if let leetCodeStats = try? JSONDecoder().decode(LeetCodeResponse.self, from: data) {
                print("✅ Widget: Successfully decoded LeetCode data")
                print("✅ Widget: Username: \(leetCodeStats.data.matchedUser.username)")
                
                let heatmapData = processHeatmapData(from: leetCodeStats)
                let totalSubmissions = leetCodeStats.data.matchedUser.userCalendar.dailySubmissions.values.reduce(0, +)
                let userName = leetCodeStats.data.matchedUser.username
                
                print("✅ Widget: Processed heatmap data count: \(heatmapData.count)")
                print("✅ Widget: Total submissions: \(totalSubmissions)")
                
                completion(heatmapData, totalSubmissions, userName)
            } else {
                print("❌ Widget: Failed to decode data from UserDefaults")
                // Fallback to placeholder data
                completion(generatePlaceholderData(), 247, "username")
            }
        } else {
            print("❌ Widget: No data found in UserDefaults")
            // Fallback to placeholder data
            completion(generatePlaceholderData(), 247, "username")
        }
    }
    
    private func processHeatmapData(from leetCodeStats: LeetCodeResponse) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = Date()
        let userCalendar = leetCodeStats.data.matchedUser.userCalendar
        
        // Use EXACTLY the same logic as HomeContentView
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
        
        // Get our submission data exactly like HomeContentView
        return (0..<daysToLookBack).compactMap { dayOffset -> (date: Date, count: Int)? in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            let timestamp = String(Int(floor(date.timeIntervalSince1970 / 86400) * 86400))
            let count = userCalendar.dailySubmissions[timestamp] ?? 0
            return (date: date, count: count)
        }.sorted { $0.date < $1.date }
    }
}

// MARK: - Widget View
struct LeetCodeHeatmapWidgetView: View {
    let entry: LeetCodeProvider.Entry
    
    var body: some View {
        ZStack {
            Color.backgroundColour
                .edgesIgnoringSafeArea(.all)
            
            // For debugging - replace with heatmap once working
            VStack {
                Text("Widget Debug")
                Text("Data count: \(entry.heatmapData.count)")
                Text("User: \(entry.userName ?? "no user")")
                Text("Submissions: \(entry.totalSubmissions)")
                
                if entry.heatmapData.count > 100 {
                    Text("✅ Real data")
                        .foregroundColor(.green)
                } else {
                    Text("❌ Placeholder data")
                        .foregroundColor(.red)
                }
            }
            .font(.caption)
            .padding()
            
            /* Uncomment this when debugging is done:
            // Match HomeContentView exactly
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
                    
                    if absoluteIndex < entry.heatmapData.count {
                        let submissionData = entry.heatmapData[absoluteIndex]
                        
                        if submissionData.count == 0 {
                            Rectangle()
                                .foregroundColor(Color.backgroundColourThree)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(3)
                                .cornerRadius(6, corners: corners)
                        } else {
                            let nonZeroSubmissions = entry.heatmapData.map { $0.count }.filter { $0 > 0 }
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
            .padding(12)
            */
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// Add this to HeatmapWidget.swift
extension Color {
    static let backgroundColour = Color(.systemBackground)
    static let backgroundColourTwo = Color(.secondarySystemBackground)
    static let backgroundColourThree = Color(.tertiarySystemBackground)
    static let fontColour = Color(.label)
    static let secondaryFontColour = Color(.secondaryLabel)
//    static let leetcodeYellow = Color.yellow
}

// MARK: - Widget Configuration
struct HeatmapWidget: Widget {
    let kind: String = "HeatmapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LeetCodeProvider()) { entry in
            LeetCodeHeatmapWidgetView(entry: entry)
        }
        .configurationDisplayName("LeetCode Heatmap")
        .description("View your LeetCode submission activity heatmap")
        .supportedFamilies([.systemMedium])
    }
}

// Only ONE @main declaration in the entire file
@main
struct HeatmapWidgetApp: WidgetBundle {
    var body: some Widget {
        HeatmapWidget()
    }
}

// This extension is needed for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct LeetCodeHeatmapWidget_Previews: PreviewProvider {
    static var previews: some View {
        LeetCodeHeatmapWidgetView(entry: LeetCodeEntry(
            date: Date(),
            heatmapData: Array(0..<119).map { offset in
                let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
                return (date: date, count: Int.random(in: 0...5))
            },
            totalSubmissions: 247,
            userName: "username"
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
