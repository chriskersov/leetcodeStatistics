//
//  ContentView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 28/12/2024.
//

import SwiftUI
import CoreData

struct WelcomeView: View {
    var body: some View {
        @State var username = ""
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
                
                Button("Let's Go") {
                    // action here
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .font(.leetcodeFontLetsGo)
                .background(Color.backgroundColourTwoDark)
                .foregroundColor(.fontColourGrey)
                .cornerRadius(5)
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
