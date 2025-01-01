//
//  ContentView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/12/2024.
//

import SwiftUI
import CoreData

struct WelcomeView: View {
    @State private var username = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    func fetchLeetCodeStats() async {
        print("Starting API call for username: \(username)")  // Add this
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
            errorMessage = "Invalid URL"
            showError = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["query": query]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("Making network request...")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Got response: \(response)")
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response data: \(jsonString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                showError = true
                return
            }
            
            // Updated decoding part
            let decoder = JSONDecoder()
            
            let leetCodeResponse = try decoder.decode(LeetCodeResponse.self, from: data)
            let user = leetCodeResponse.data.matchedUser
                    
            print("\nUser Profile:")
            print("-------------------------")
            print("Username: \(user.username)")
            print("Rank: \(user.profile.ranking)")
            print("Reputation: \(user.profile.reputation)")
            print("Profile Views: \(user.profile.postViewCount)")

            // Calculate acceptance rate from accepted submissions vs total submissions
            let totalAcceptedSubmissions = user.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
            let totalSubmissions = user.submitStats.totalSubmissionNum.first(where: { $0.difficulty == "All" })?.submissions ?? 0
            let acceptanceRate = totalSubmissions > 0 ? (Double(totalAcceptedSubmissions) / Double(totalSubmissions) * 100) : 0

            print("\nSubmission Overview:")
            print("-------------------------")
            print("Total Problems Solved: \(user.submitStats.acSubmissionNum.first(where: { $0.difficulty == "All" })?.count ?? 0)")
            print("Total Submissions: \(totalSubmissions)")
            print("Acceptance Rate: \(String(format: "%.1f", acceptanceRate))%")

            print("\nProblem Solving Statistics:")
            print("-------------------------")
            ["Easy", "Medium", "Hard"].forEach { difficulty in
                let solved = user.submitStats.acSubmissionNum.first(where: { $0.difficulty == difficulty })?.count ?? 0
                print("\(difficulty):")
                print("  - Solved: \(solved)")
            }

            print("\nActivity Statistics:")
            print("-------------------------")
            print("Active Days: \(user.userCalendar.totalActiveDays)")
            print("Current Streak: \(user.userCalendar.streak)")

            print("\nRecent Submissions:")
            print("-------------------------")
            leetCodeResponse.data.recentAcSubmissionList.forEach { submission in
                if let timestamp = Int(submission.timestamp) {
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    
                    print("\(formatter.string(from: date))")
                    print("  - Problem: \(submission.title)")
                    print("  - Language: \(submission.langName)")
                    print("")
                }
            }
            
        } catch let decodingError as DecodingError {
            // Handle specific decoding errors
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Missing key: \(key)\nContext: \(context)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type)\nContext: \(context)")
            case .valueNotFound(let type, let context):
                print("Value not found: \(type)\nContext: \(context)")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            @unknown default:
                print("Unknown decoding error: \(decodingError)")
            }
            errorMessage = "Error decoding response: \(decodingError.localizedDescription)"
            showError = true
        } catch {
            print("Error occurred: \(error)")
            errorMessage = "Error: \(error.localizedDescription)"
            showError = true
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {

                Spacer()
                
                HStack(spacing: 0) {
                    Text("Enter your ")
                        .font(.leetcodeFont)
                        .foregroundColor(.fontColourWhite)
                    Text("LeetCode")
                        .font(.leetcodeFont)
                        .foregroundColor(.leetcodeYellow)
                }
                Text("username")
                    .font(.leetcodeFont)
                    .foregroundColor(.fontColourWhite)
                    .padding(.bottom, 15)
                
                TextField("Username", text: $username)
                    .font(.leetcodeFontUsername)
                    .background(Color.backgroundColourDark)
                    .foregroundColor(.fontColourGrey)
                    .padding(10)
                    .accentColor(.fontColourGrey)
                    .frame(height: 40)
                    .cornerRadius(12)
                    .overlay( // Add white border
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.fontColourGrey, lineWidth: 1.5)
                    )
                    .padding(.bottom, 15)
                
                Button(action: {
                    if !username.isEmpty {
                        isLoading = true
                        // Create a Task to run our async function
                        Task {
                            await fetchLeetCodeStats()
                            isLoading = false
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .leetcodeYellow))
                    } else {
                        Text("Let's Go")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .font(.leetcodeFontLetsGo)
                .background(Color.leetcodeYellowTwo)
                .foregroundColor(.leetcodeYellow)
                .cornerRadius(5)
                .disabled(username.isEmpty || isLoading)
            }
            .padding()
        }
        .alert("Error", isPresented: $showError, presenting: errorMessage) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error)
        }
    }
}



#Preview {
    WelcomeView()
}
