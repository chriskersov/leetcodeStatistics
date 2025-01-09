//
//  URLSession.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 09/01/2025.
//
import SwiftUI

extension URLSession {
   func fetchProfileImage(username: String) async throws -> UIImage? {
       let profileURL = URL(string: "https://leetcode.com/u/\(username)")!
       var request = URLRequest(url: profileURL)
       request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
       request.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
       
       let (data, _) = try await URLSession.shared.data(for: request)
       let html = String(data: data, encoding: .utf8) ?? ""
       
       print(html)
       
       let pattern = "<img class=\"h-20 w-20 rounded-lg object-cover\"[^>]*src=\"([^\"]*)\""
       guard let regex = try? NSRegularExpression(pattern: pattern),
             let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
             let range = Range(match.range(at: 1), in: html) else {
           print("No match found")
           return nil
       }
       
       let avatarURL = String(html[range])
       print("Found URL: \(avatarURL)")
       
       guard let imageURL = URL(string: avatarURL),
             let (imageData, _) = try? await URLSession.shared.data(from: imageURL) else {
           return nil
       }
       
       return UIImage(data: imageData)
   }
}
