//
//  CardBackView.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI

struct CardBackView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color(red: 0.6, green: 0, blue: 0)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 4)
                        .padding(2)
                )
            
            // Pattern
            VStack(spacing: 4) {
                ForEach(0..<12) { _ in
                    HStack(spacing: 4) {
                        ForEach(0..<8) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 3, height: 3)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(width: 80, height: 120)
    }
}
