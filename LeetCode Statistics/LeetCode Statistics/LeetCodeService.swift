//
//  LeetCodeService.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 03/01/2025.
//

// LeetCodeService.swift

import Foundation

class LeetCodeService {
    static func fetchStats(username: String) async throws -> LeetCodeResponse {
        let query = """
        {
          matchedUser(username: "\(username)") {
            username
            profile {
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
        
        return try JSONDecoder().decode(LeetCodeResponse.self, from: data)
    }
}
