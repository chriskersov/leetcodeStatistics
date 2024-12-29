//
//  ContentView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/12/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        VStack {
            Text("leetcode statistics")
        }
        .padding()
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
