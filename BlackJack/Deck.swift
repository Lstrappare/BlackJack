//
//  Deck.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import Foundation

/// Representa un mazo de cartas estándar.
///
/// Permite crear, barajar y sacar cartas del mazo.
/// Internamente mantiene un arreglo de `Card`.
struct Deck {

    /// Cartas que componen el mazo.
    ///
    /// Es privado para evitar modificaciones externas directas.
    private var cards: [Card] = []

    /// Inicializa un mazo nuevo con todas las combinaciones de cartas.
    init() {
        createDeck()
    }

    // MARK: - Deck Creation

    /// Crea un mazo completo recorriendo todos los palos y rangos.
    ///
    /// Si el mazo ya tenía cartas, se reinicia.
    mutating func createDeck() {
        cards = []

        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let newCard = Card(rank: rank, suit: suit)
                cards.append(newCard)
            }
        }
    }

    // MARK: - Game Actions

    /// Extrae una carta del mazo.
    ///
    /// - Returns: La carta extraída.
    /// - Warning: Debe asegurarse que el mazo no esté vacío antes de llamar a este método.
    mutating func drawCard() -> Card {
        cards.removeLast()
    }

    /// Baraja las cartas del mazo de forma aleatoria.
    mutating func shuffle() {
        cards.shuffle()
    }

    // MARK: - State

    /// Número de cartas restantes en el mazo.
    var count: Int {
        cards.count
    }
}
