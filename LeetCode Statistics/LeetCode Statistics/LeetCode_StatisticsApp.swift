//
//  LeetCode_StatisticsApp.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/12/2024.
//

import SwiftUI

@main
struct LeetCode_StatisticsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
