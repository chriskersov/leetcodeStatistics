//
//  UserManager.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 29/01/2025.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    static let shared = UserManager()
    @Published var currentUsername: String?
    @Published var currentStats: LeetCodeResponse?
    
    private let userDefaults = UserDefaults.standard
    private let usernameKey = "leetcode_username"
    
    private var statsFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("leetcode_stats.json")
    }
    
    init() {
        // Load saved username
        currentUsername = userDefaults.string(forKey: usernameKey)
        // Try to load saved stats
        loadSavedStats()
    }
    
    func saveUsername(_ username: String) {
        currentUsername = username
        userDefaults.set(username, forKey: usernameKey)
    }
    
    func clearUsername() {
        currentUsername = nil
        userDefaults.removeObject(forKey: usernameKey)
    }
    
    func saveStats(_ stats: LeetCodeResponse) {
        currentStats = stats
        
        // Save to file
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stats)
            try data.write(to: statsFileURL)
        } catch {
            print("Error saving stats: \(error)")
        }
    }
    
    private func loadSavedStats() {
        do {
            let data = try Data(contentsOf: statsFileURL)
            let decoder = JSONDecoder()
            currentStats = try decoder.decode(LeetCodeResponse.self, from: data)
        } catch {
            print("Error loading stats: \(error)")
        }
    }
    
    func clearAllData() {
        clearUsername()
        currentStats = nil
        try? FileManager.default.removeItem(at: statsFileURL)
    }
}
