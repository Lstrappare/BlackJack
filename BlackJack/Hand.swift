//
//  Hand.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import Foundation

/// Representa una mano individual del jugador.
///
/// Necesario para soportar "Split", donde el jugador puede tener múltiples manos.
struct Hand: Identifiable {
    let id = UUID()
    
    /// Cartas en esta mano
    var cards: [Card] = []
    
    /// Apuesta asignada a esta mano
    var bet: Int
    
    /// Indica si la mano ya terminó su turno (se plantó o se pasó)
    var isCompleted: Bool = false
    
    /// Indica si se dobló la apuesta (solo recibe 1 carta más)
    var isDoubled: Bool = false
    
    /// Puntaje actual de la mano
    var score: Int {
        GameViewModel.calculateScore(of: cards)
    }
    
    /// Indica si la mano se pasó de 21
    var isBusted: Bool {
        score > 21
    }
    
    /// Indica si es un Blackjack (21 con 2 cartas)
    var isBlackjack: Bool {
        cards.count == 2 && score == 21 && !isDoubled // Doubled hand cannot be natural blackjack technically? Usually split aces cannot be BJ.
    }
}
