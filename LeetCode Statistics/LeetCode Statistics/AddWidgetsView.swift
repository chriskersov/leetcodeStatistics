//
//  AddWidgetsView.swift
//  LeetCode Statistics
//
//  Created by chris kersov on 10/02/2025.
//
import SwiftUI

struct AddWidgetsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundColourDark
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack{
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("How to Add Widgets")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.fontColourWhite)
                            
                            Spacer()
                            
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.fontColourWhite)
                                    .font(.system(size: 24, weight: .medium))
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Text("gonna be a video here demonstrating how to add widgets")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.fontColourWhite)
                        Text("i guess just screen record me doing it on my iphone")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.fontColourWhite)
                        
                        Spacer()
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.backgroundColourTwoDark)
                .cornerRadius(5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

#Preview {
    WelcomeView()
}
