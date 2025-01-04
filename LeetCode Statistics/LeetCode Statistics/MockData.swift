//
//  File.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 04/01/2025.
//

import Foundation

struct MockData {
    static let sampleResponse = LeetCodeResponse(
        data: DataClass(
            matchedUser: MatchedUser(
                username: "LeetCoder",
                profile: Profile(
                    ranking: 254789,
                    reputation: 850,
                    starRating: 4.5,
                    postViewCount: 1234
                ),
                submitStats: SubmitStats(
                    acSubmissionNum: [
                        SubmissionNum(difficulty: "All", count: 189, submissions: 250),
                        SubmissionNum(difficulty: "Easy", count: 108, submissions: 140),
                        SubmissionNum(difficulty: "Medium", count: 71, submissions: 90),
                        SubmissionNum(difficulty: "Hard", count: 10, submissions: 20)
                    ],
                    totalSubmissionNum: [
                        SubmissionNum(difficulty: "All", count: 189, submissions: 340),
                        SubmissionNum(difficulty: "Easy", count: 108, submissions: 180),
                        SubmissionNum(difficulty: "Medium", count: 71, submissions: 130),
                        SubmissionNum(difficulty: "Hard", count: 10, submissions: 30)
                    ]
                ),
                userCalendar: UserCalendar(
                    activeYears: [2023, 2024],
                    streak: 15,
                    totalActiveDays: 156,
                    dccBadges: [],
                    submissionCalendar: ""
                )
            ),
            recentAcSubmissionList: [
                RecentSubmission(
                    id: "1",
                    title: "Two Sum",
                    titleSlug: "two-sum",
                    timestamp: "1704321600",
                    langName: "Swift"
                ),
                RecentSubmission(
                    id: "2",
                    title: "Add Two Numbers",
                    titleSlug: "add-two-numbers",
                    timestamp: "1704235200",
                    langName: "Python"
                ),
                RecentSubmission(
                    id: "3",
                    title: "Longest Substring Without Repeating Characters",
                    titleSlug: "longest-substring",
                    timestamp: "1704148800",
                    langName: "Swift"
                )
            ]
        )
    )
}
