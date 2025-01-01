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
          matchedUser(username: "${username}") {
            username
            profile {
              ranking
              reputation
              starRating
              viewCount
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
            submitStatsGlobal {
              acSubmissionNum {
                difficulty
                count
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
            
            print("Username: \(user.username)")
            print("Ranking: \(user.profile.ranking)")
            print("Reputation: \(user.profile.reputation)")
            print("Views: \(user.profile.viewCount)")
            
            if let calendarData = user.userCalendar.submissionCalendar.data(using: .utf8),
               let calendarDict = try? JSONSerialization.jsonObject(with: calendarData) as? [String: Int] {
                // Process submission calendar data
                print("Submission calendar entries: \(calendarDict.count)")
            }
            
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
