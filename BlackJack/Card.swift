//
//  Card.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import Foundation

/// Representa los palos de una baraja estándar.
///
/// El `rawValue` corresponde al símbolo visual del palo.
enum Suit: String, CaseIterable {
    case spades = "♠️"
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
}

/// Representa el rango de una carta (2–A).
///
/// - Note:
///   El `rawValue` se usa como identificador numérico,
///   mientras que `value` representa los puntos en Blackjack.
enum Rank: Int, CaseIterable {

    /// Cartas numéricas (2–10)
    case two = 2, three, four, five, six, seven, eight, nine, ten

    /// Cartas con figura
    case jack, queen, king, ace

    // MARK: - Game Logic

    /// Valor de la carta según las reglas de Blackjack.
    ///
    /// - Returns: Puntos que aporta la carta al jugador.
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

    // MARK: - Display

    /// Etiqueta visual del rango (J, Q, K, A o número).
    var label: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return String(self.rawValue)
        }
    }
}

/// Representa una carta individual de la baraja.
///
/// Cumple con `Identifiable` para su uso en SwiftUI.
struct Card: Identifiable {

    /// Identificador único de la carta.
    let id = UUID()

    /// Rango de la carta.
    let rank: Rank

    /// Palo de la carta.
    let suit: Suit

    /// Texto descriptivo para mostrar en la interfaz.
    var displayTitle: String {
        "\(rank.label) de \(suit.rawValue)"
    }
}
