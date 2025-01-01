//
//  LeetCodeUser.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 31/12/2024.
//

// Main response structures for the LeetCode API
struct LeetCodeResponse: Codable {
    let data: LeetCodeData
}

struct LeetCodeData: Codable {
    let matchedUser: MatchedUser
    let recentAcSubmissionList: [RecentSubmission]  // Note the exact casing
}

struct RecentSubmission: Codable {
    let id: String
    let title: String
    let titleSlug: String
    let timestamp: String
    let langName: String
}

struct MatchedUser: Codable {
    let username: String
    let profile: Profile
    let submitStats: SubmitStats
    let userCalendar: UserCalendar
    // Removed recentACSubmissionList from here since it's at the top level
}

struct Profile: Codable {
    let ranking: Int
    let reputation: Int
    let starRating: Double
    let postViewCount: Int
}

struct SubmitStats: Codable {
    let acSubmissionNum: [SubmissionCount]
    let totalSubmissionNum: [SubmissionCount]
}

struct SubmissionCount: Codable {
    let difficulty: String
    let count: Int
    let submissions: Int
}

struct ProblemSolvedStat: Codable {
    let difficulty: String
    let percentage: Double?
}

struct UserCalendar: Codable {
    let activeYears: [Int]
    let streak: Int
    let totalActiveDays: Int
    let dccBadges: [DccBadge]
    let submissionCalendar: String
}

struct DccBadge: Codable {
    let timestamp: Int
    let badge: Badge
}

struct Badge: Codable {
    let name: String
    let icon: String
}
