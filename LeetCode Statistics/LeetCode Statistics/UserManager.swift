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
    @Published var shouldClearTextField = false
    
    private let userDefaults = UserDefaults.standard
    private let usernameKey = "leetcode_username"
    private let lastUpdateKey = "last_update_timestamp"
    private let updateInterval: TimeInterval = 3600 // 1 hour in seconds
    
    private var statsFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("leetcode_stats.json")
    }
    
    init() {
        currentUsername = userDefaults.string(forKey: usernameKey)
        loadSavedStats()
        checkForUpdate()
    }
    
    private func checkForUpdate() {
        guard let username = currentUsername else { return }
        
        let lastUpdate = userDefaults.double(forKey: lastUpdateKey)
        let currentTime = Date().timeIntervalSince1970
        
        if currentTime - lastUpdate >= updateInterval {
            Task {
                await refreshStats(for: username)
            }
        }
    }
    
    func refreshStats(for username: String) async {
        do {
            let stats = try await LeetCodeService.fetchStats(username: username)
            await MainActor.run {
                self.currentStats = stats
                self.saveStats(stats)
                self.userDefaults.set(Date().timeIntervalSince1970, forKey: lastUpdateKey)
            }
        } catch {
            print("Error refreshing stats: \(error)")
        }
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
