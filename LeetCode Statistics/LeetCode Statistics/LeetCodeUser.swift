//
//  LeetCodeUser.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 31/12/2024.
//

struct LeetCodeResponse: Codable {
    let data: LeetCodeUser
}

struct LeetCodeUser: Codable {
    let matchedUser: MatchedUser
    
    struct MatchedUser: Codable {
        let username: String
        let submitStats: SubmitStats
        
        struct SubmitStats: Codable {
            let acSubmissionNum: [ACSubmission]
            
            struct ACSubmission: Codable {
                let count: Int
                let difficulty: String
            }
        }
    }
}
