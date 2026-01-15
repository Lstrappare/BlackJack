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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                        .padding(4)
                )
            
            // Pattern
            VStack(spacing: 5) {
                ForEach(0..<10) { _ in
                    HStack(spacing: 5) {
                        ForEach(0..<6) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
        }
        .frame(width: 80, height: 120)
    }
}
