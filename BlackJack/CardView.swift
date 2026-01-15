//
//  CardView.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI

/// Vista visual para una carta individual.
struct CardView: View {
    let card: Card
    
    // Determinar el color según el palo
    private var suitColor: Color {
        switch card.suit {
        case .hearts, .diamonds:
            return .red
        case .spades, .clubs:
            return .black
        }
    }
    
    var body: some View {
        ZStack {
            // Fondo de la carta
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            VStack {
                // Esquina superior izquierda
                HStack {
                    VStack(spacing: 0) {
                        Text(card.rank.label)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                        Text(card.suit.rawValue)
                            .font(.system(size: 14))
                    }
                    Spacer()
                }
                
                Spacer()
                
                // Centro grande
                Text(card.suit.rawValue)
                    .font(.system(size: 40))
                
                Spacer()
                
                // Esquina inferior derecha (invertida)
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Text(card.rank.label)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                        Text(card.suit.rawValue)
                            .font(.system(size: 14))
                    }
                    .rotationEffect(.degrees(180))
                }
            }
            .padding(8)
            .foregroundColor(suitColor)
        }
        .frame(width: 80, height: 120) // Tamaño fijo estándar para la carta
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardView(card: Card(rank: .ace, suit: .spades))
            CardView(card: Card(rank: .ten, suit: .hearts))
            CardView(card: Card(rank: .king, suit: .diamonds))
        }
        .padding()
        .background(Color.green)
        .previewLayout(.sizeThatFits)
    }
}
