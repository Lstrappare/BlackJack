//
//  Card.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import Foundation

// 1. PALOS (Suits)
enum Suit: String, CaseIterable {
    case spades = "♠️"
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
}

// 2. RANGO (Rank)
enum Rank: Int, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace // Estos no tienen número asignado aquí
    
    // Propiedad calculada: El valor numérico para el juego
    var value: Int {
        switch self {
        case .jack, .queen, .king:
            return 10
        case .ace:
            return 11
        default:
            return self.rawValue
        }
    }
    
    // Símbolo del valor de la carta en vez de un número
    var label: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return String(self.rawValue)
        }
    }
}

// 3. LA CARTA (Struct)
struct Card: Identifiable {
    let id = UUID() // Identificador único
    let rank: Rank
    let suit: Suit
    
    // Propiedad para mostrar el texto en pantalla
    var displayTitle: String {
        return "\(rank.label) de \(suit.rawValue)"
    }
}
