//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI
import Combine

/// ViewModel principal del juego de Blackjack.
///
/// Se encarga de manejar la lógica del juego, el estado del mazo,
/// las cartas del jugador y del dealer, y de notificar a la vista
/// cuando el estado cambia.
class GameViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Mazo de cartas del juego.
    ///
    /// Se reinicia y baraja al comenzar una nueva partida.
    @Published var deck = Deck()

    /// Cartas en la mano del jugador.
    @Published var playerCards: [Card] = []

    /// Cartas en la mano del dealer.
    @Published var dealerCards: [Card] = []

    /// Indica si la partida ha terminado.
    @Published var isGameOver = false

    /// Mensaje informativo para mostrar en la interfaz.
    @Published var message = ""

    // MARK: - Game Control

    /// Inicia una nueva partida de Blackjack.
    ///
    /// Reinicia el estado del juego, crea y baraja el mazo,
    /// limpia las manos y reparte dos cartas al jugador
    /// y dos al dealer.
    func startGame() {
        isGameOver = false
        message = ""

        deck.createDeck()
        deck.shuffle()

        playerCards = []
        dealerCards = []

        // Repartir 2 cartas a cada jugador
        playerCards.append(deck.drawCard())
        dealerCards.append(deck.drawCard())
        playerCards.append(deck.drawCard())
        dealerCards.append(deck.drawCard())
    }

    // MARK: - Scoring

    /// Calcula el puntaje total de una mano según las reglas de Blackjack.
    ///
    /// Las cartas J, Q y K valen 10 puntos.
    /// El As vale inicialmente 11 puntos, pero si el puntaje total
    /// supera 21, el As puede ajustarse dinámicamente a 1 punto
    /// para evitar que la mano se pase.
    ///
    /// - Parameter hand: Arreglo de cartas que conforman la mano.
    /// - Returns: Puntaje total calculado.
    func calculateScore(of hand: [Card]) -> Int {
        var score = 0
        var aceCount = 0

        // Suma inicial de todas las cartas
        for card in hand {
            score += card.rank.value

            if card.rank == .ace {
                aceCount += 1
            }
        }

        // Ajuste dinámico del valor del As
        // Mientras el puntaje sea mayor a 21 y existan ases disponibles,
        // se reduce el puntaje restando 10 (11 → 1).
        while score > 21 && aceCount > 0 {
            score -= 10
            aceCount -= 1
        }

        return score
    }
}
