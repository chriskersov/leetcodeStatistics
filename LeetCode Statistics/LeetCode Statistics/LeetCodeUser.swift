//
//  LeetCodeUser.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 31/12/2024.
//

// Main response structures for the LeetCode API
// Models.swift

import Foundation

struct LeetCodeResponse: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let matchedUser: MatchedUser
    let recentAcSubmissionList: [RecentSubmission]
}

struct MatchedUser: Codable {
    let username: String
    let profile: Profile
    let submitStats: SubmitStats
    let userCalendar: UserCalendar
}

struct Profile: Codable {
    let ranking: Int
    let reputation: Int
    let starRating: Double
    let postViewCount: Int
}

struct SubmitStats: Codable {
    let acSubmissionNum: [SubmissionNum]
    let totalSubmissionNum: [SubmissionNum]
}

struct SubmissionNum: Codable {
    let difficulty: String
    let count: Int
    let submissions: Int
}

struct UserCalendar: Codable {
    let activeYears: [Int]
    let streak: Int
    let totalActiveDays: Int
    let dccBadges: [DccBadge]  // Verify API uses "dccBadges" not "docBadges"
    let submissionCalendar: String
    
    // Improved parsing with error handling
    var dailySubmissions: [String: Int] {
        guard !submissionCalendar.isEmpty,
              let data = submissionCalendar.data(using: .utf8) else {
            print("Empty or invalid submissionCalendar string")
            return [:]
        }
        
        do {
            return try JSONDecoder().decode([String: Int].self, from: data)
        } catch {
            print("Failed to parse submissionCalendar: \(error)")
            return [:]
        }
    }
}

struct DccBadge: Codable {
    let timestamp: Int
    let badge: Badge
}

struct Badge: Codable {
    let name: String
    let icon: String
}

struct RecentSubmission: Codable {
    let id: String
    let title: String
    let titleSlug: String
    let timestamp: String
    let langName: String
}
