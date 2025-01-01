//
//  LeetCodeUser.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 31/12/2024.
//

// Main response structure
struct LeetCodeResponse: Codable {
    let data: LeetCodeData
}

struct LeetCodeData: Codable {
    let matchedUser: MatchedUser
}

struct MatchedUser: Codable {
    let username: String
    let profile: Profile
    let submitStats: SubmitStats
    let submitStatsGlobal: SubmitStats
    let userCalendar: UserCalendar
}

struct Profile: Codable {
    let ranking: Int
    let reputation: Int
    let starRating: Double
    let viewCount: Int
}

struct SubmitStats: Codable {
    let acSubmissionNum: [SubmissionCount]
    let totalSubmissionNum: [SubmissionCount]
}

struct SubmissionCount: Codable {
    let difficulty: String
    let count: Int
    let submissions: Int?
}

struct UserCalendar: Codable {
    let activeYears: [Int]
    let streak: Int
    let totalActiveDays: Int
    let dccBadges: [DccBadge]
    let submissionCalendar: String // This will be a JSON string that needs to be parsed
}

struct DccBadge: Codable {
    let timestamp: Int
    let badge: Badge
}

struct Badge: Codable {
    let name: String
    let icon: String
}
