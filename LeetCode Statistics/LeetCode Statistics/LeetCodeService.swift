//
//  LeetCodeService.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/2025.
//

import Foundation
import WidgetKit  // Add this import

class LeetCodeService {
    static func fetchStats(username: String) async throws -> LeetCodeResponse {
        let query = """
        {
          matchedUser(username: "\(username)") {
            username
            profile {
              realName
              userAvatar
              ranking
              reputation
              starRating
              postViewCount
            }
            submitStats {
              acSubmissionNum {
                difficulty
                count
                submissions
              }
              totalSubmissionNum {
                difficulty
                count
                submissions
              }
            }
            userCalendar {
              activeYears
              streak
              totalActiveDays
              dccBadges {
                timestamp
                badge {
                  name
                  icon
                }
              }
              submissionCalendar
            }
          }
          recentAcSubmissionList(username: "\(username)", limit: 10) {
            id
            title
            titleSlug
            timestamp
            langName
          }
        }
        """
        
        guard let url = URL(string: "https://leetcode.com/graphql") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["query": query]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let leetCodeStats = try JSONDecoder().decode(LeetCodeResponse.self, from: data)
        
        // After you get your leetCodeStats in your main app
        let sharedDefaults = UserDefaults(suiteName: "group.com.chriskersov.leetcodestatistics")
        do {
            let data = try JSONEncoder().encode(leetCodeStats)
            sharedDefaults?.set(data, forKey: "leetcode_data")
            
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("❌ Main App: Failed to save data: \(error)")
        }
        
        // Request widget refresh
        WidgetCenter.shared.reloadAllTimelines()
        
        return leetCodeStats
    }
}
