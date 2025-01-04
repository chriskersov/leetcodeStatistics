//
//  ContentView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/12/2024.
//

//import SwiftUI
//
//struct WelcomeView: View {
//    @State private var username = ""
//    @State private var isLoading = false
//    @State private var errorMessage: String?
//    @State private var showError = false
//    @State private var leetCodeStats: LeetCodeResponse?
//    
//    var body: some View {
//        if let stats = leetCodeStats {
//            HomeView(leetCodeStats: stats)
//        } else {
//            ZStack {
//                Color.backgroundColourDark
//                    .edgesIgnoringSafeArea(.all)
//                VStack(alignment: .leading) {
//                    Spacer()
//                    
//                    HStack(spacing: 0) {
//                        Text("Enter your ")
//                            .font(.leetcodeFont)
//                            .foregroundColor(.fontColourWhite)
//                        Text("LeetCode")
//                            .font(.leetcodeFont)
//                            .foregroundColor(.leetcodeYellow)
//                    }
//                    Text("username")
//                        .font(.leetcodeFont)
//                        .foregroundColor(.fontColourWhite)
//                        .padding(.bottom, 15)
//                    
//                    TextField("Username", text: $username)
//                        .font(.leetcodeFontUsername)
//                        .background(Color.backgroundColourDark)
//                        .foregroundColor(.fontColourGrey)
//                        .padding(10)
//                        .accentColor(.fontColourGrey)
//                        .frame(height: 40)
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.fontColourGrey, lineWidth: 1.5)
//                        )
//                        .padding(.bottom, 15)
//                    
//                    Button(action: {
//                        if !username.isEmpty {
//                            isLoading = true
//                            Task {
//                                do {
//                                    leetCodeStats = try await LeetCodeService.fetchStats(username: username)
//                                } catch {
//                                    errorMessage = error.localizedDescription
//                                    showError = true
//                                }
//                                isLoading = false
//                            }
//                        }
//                    }) {
//                        if isLoading {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle(tint: .leetcodeYellow))
//                        } else {
//                            Text("Let's Go")
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 40)
//                    .font(.leetcodeFontLetsGo)
//                    .background(Color.leetcodeYellowTwo)
//                    .foregroundColor(.leetcodeYellow)
//                    .cornerRadius(5)
//                    .disabled(username.isEmpty || isLoading)
//                }
//                .padding()
//            }
//            .alert("Error", isPresented: $showError, presenting: errorMessage) { _ in
//                Button("OK", role: .cancel) {}
//            } message: { error in
//                Text(error)
//            }
//        }
//    }
//}
//
//#Preview {
//    WelcomeView()
//}

// ----------------------------------------------------------------------------

import SwiftUI

struct WelcomeView: View {
    @State private var username = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var leetCodeStats: LeetCodeResponse?
    
    var body: some View {
        if let stats = leetCodeStats {
            HomeView(leetCodeStats: stats)
        } else {
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.fontColourGrey, lineWidth: 1.5)
                        )
                        .padding(.bottom, 15)
                    
                    Button(action: {
                        if !username.isEmpty {
                            leetCodeStats = MockData.sampleResponse
                        }
                    }) {
                        Text("Let's Go")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .font(.leetcodeFontLetsGo)
                    .background(Color.leetcodeYellowTwo)
                    .foregroundColor(.leetcodeYellow)
                    .cornerRadius(5)
                    .disabled(username.isEmpty)
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
}

#Preview {
    WelcomeView()
}
