//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI
import Combine

enum GameState {
    case playerTurn
    case dealerTurn
    case gameOver
}

/// ViewModel principal del juego de Blackjack.
///
/// Se encarga de:
/// - Manejar la lógica del juego
/// - Administrar el estado del mazo y las manos
/// - Calcular puntajes
/// - Notificar a la vista cuando el estado cambia
///
/// Sigue el patrón MVVM, separando completamente
/// la lógica de negocio de la interfaz.
class GameViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Mazo de cartas del juego.
    ///
    /// Se crea y baraja al iniciar una nueva partida.
    @Published var deck = Deck()

    /// Cartas actuales en la mano del jugador.
    @Published var playerCards: [Card] = []

    /// Cartas actuales en la mano del dealer.
    @Published var dealerCards: [Card] = []

    /// Estado actual del juego
    @Published var gameState: GameState = .playerTurn
    
    /// Indica si la partida ha terminado (helper property)
    var isGameOver: Bool {
        gameState == .gameOver
    }

    /// Mensaje informativo mostrado al finalizar la partida.
    @Published var message = ""

    // MARK: - Game Control

    /// Inicia una nueva partida de Blackjack.
    ///
    /// - Reinicia el estado del juego
    /// - Crea y baraja el mazo
    /// - Limpia las manos
    /// - Reparte dos cartas al jugador y al dealer
    func startGame() {
        gameState = .playerTurn
        message = ""

        deck.createDeck()
        deck.shuffle()

        playerCards = []
        dealerCards = []

        // Repartir 2 cartas a cada uno
        playerCards.append(deck.drawCard())
        dealerCards.append(deck.drawCard())
        playerCards.append(deck.drawCard())
        dealerCards.append(deck.drawCard())
    }

    // MARK: - Scoring

    /// Calcula el puntaje total de una mano según las reglas del Blackjack.
    ///
    /// Reglas aplicadas:
    /// - Las cartas J, Q y K valen 10 puntos
    /// - El As vale inicialmente 11 puntos
    /// - Si el puntaje supera 21, el As puede ajustarse dinámicamente a 1
    ///   para evitar que la mano se pase
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

        // Ajuste dinámico del valor del As (11 → 1)
        while score > 21 && aceCount > 0 {
            score -= 10
            aceCount -= 1
        }

        return score
    }

    // MARK: - Player Actions

    /// Acción del jugador para pedir una carta.
    ///
    /// - Verifica que la partida no haya terminado
    /// - Saca una carta del mazo y la añade a la mano
    /// - Recalcula el puntaje del jugador
    /// - Detecta si el jugador se pasa de 21 (Bust)
    /// - Ejecuta retroalimentación háptica según el resultado
    func playerHit() {
        // Evitar acciones si no es el turno del jugador
        guard gameState == .playerTurn else { return }

        // Sacar una carta del mazo
        let newCard = deck.drawCard()
        playerCards.append(newCard)

        // Recalcular puntaje
        let score = calculateScore(of: playerCards)

        // Verificar si el jugador perdió
        if score > 21 {
            // Player Bust = Dealer instant win regardless of dealer cards
            gameState = .gameOver
            message = "¡Te pasaste! 💥 Perdiste."
            playHaptic(type: .error)
        } else {
            playHaptic(type: .success)
        }
    }
    
    /// Acción del jugador para plantarse.
    ///
    /// - Termina el turno del jugador
    /// - Inicia el turno del dealer
    func playerStand() {
        guard gameState == .playerTurn else { return }
        gameState = .dealerTurn
        
        // Iniciar turno del dealer despues de una pequeña pausa para UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playDealerTurn()
        }
    }
    
    // MARK: - Dealer Actions
    
    func playDealerTurn() {
        var score = calculateScore(of: dealerCards)
        
        // Dealer AI: Hit until 17 or higher
        // Using recursion with delay for visualization
        
        func dealerHitRecursive() {
            score = calculateScore(of: dealerCards)
            
            if score < 17 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let newCard = self.deck.drawCard()
                    self.dealerCards.append(newCard)
                    dealerHitRecursive()
                }
            } else {
                // Dealer stops
                determineWinner()
            }
        }
        
        dealerHitRecursive()
    }
    
    func determineWinner() {
        gameState = .gameOver
        
        let playerScore = calculateScore(of: playerCards)
        let dealerScore = calculateScore(of: dealerCards)
        
        if dealerScore > 21 {
            message = "Dealer se pasó. ¡Ganaste! 🎉"
            playHaptic(type: .success)
        } else if dealerScore > playerScore {
            message = "Dealer gana con \(dealerScore). Perdiste."
            playHaptic(type: .error)
        } else if dealerScore < playerScore {
            message = "¡Ganaste con \(playerScore)! 🎉"
            playHaptic(type: .success)
        } else {
            message = "Empate a \(playerScore)."
            playHaptic(type: .warning)
        }
    }

    // MARK: - Haptics

    /// Ejecuta una vibración háptica en el dispositivo.
    ///
    /// Se utiliza para dar retroalimentación al usuario
    /// ante acciones importantes del juego.
    ///
    /// - Parameter type: Tipo de vibración (`success`, `error`, `warning`)
    func playHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
