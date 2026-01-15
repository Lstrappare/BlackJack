//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI
import Combine

enum GameState {
    case betting
    case playerTurn
    case dealerTurn
    case gameOver
}

class GameViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var deck = Deck()
    
    // Ahora soportamos múltiples manos para el jugador (Split)
    @Published var hands: [Hand] = []
    
    // Índice de la mano activa actualmente
    @Published var currentHandIndex: Int = 0
    
    @Published var dealerCards: [Card] = []
    
    @Published var gameState: GameState = .betting
    
    // Betting properties
    @Published var playerBalance: Int = 1000 // Saldo inicial
    @Published var currentBet: Int = 0
    
    @Published var message = "Haz tu apuesta"
    
    var isGameOver: Bool {
        gameState == .gameOver
    }
    
    // Helper para acceder a la mano actual facilmente
    var currentHand: Hand? {
        guard hands.indices.contains(currentHandIndex) else { return nil }
        return hands[currentHandIndex]
    }

    // MARK: - Game Control
    
    init() {
        // Inicializamos vacío, esperando apuesta
    }

    /// Inicia la fase de apuestas (resetea la mesa pero mantiene saldo)
    func startBettingPhase() {
        gameState = .betting
        currentBet = 0
        message = "Haz tu apuesta (Min 50 - Max 10000)"
        hands = []
        dealerCards = []
    }
    
    /// Coloca una apuesta inicial
    func placeBet(amount: Int) {
        guard gameState == .betting else { return }
        
        if playerBalance >= amount {
            if currentBet + amount <= 10000 {
                playerBalance -= amount
                currentBet += amount
            }
        }
    }
    
    /// Limpia la apuesta actual
    func clearBet() {
        guard gameState == .betting else { return }
        playerBalance += currentBet
        currentBet = 0
    }
    
    /// Actualiza el saldo del jugador (Max 100,000)
    func updateBalance(newBalance: Int) {
        if newBalance >= 0 && newBalance <= 100000 {
            playerBalance = newBalance
            // Si la apuesta actual es mayor al nuevo saldo (caso raro), resetear apuesta
            if currentBet > playerBalance {
                clearBet()
            }
        } else {
             message = "Saldo inválido (Max 100,000)"
             HapticManager.shared.playError()
        }
    }

    /// Inicia la ronda repartiendo cartas
    func deal() {
        guard currentBet >= 50 else {
            message = "Apuesta mínima de 50 requerida."
            return
        }
        
        deck.createDeck()
        deck.shuffle()
        
        // Crear mano inicial del jugador
        var initialHand = Hand(bet: currentBet)
        initialHand.cards.append(deck.drawCard())
        initialHand.cards.append(deck.drawCard())
        
        hands = [initialHand]
        currentHandIndex = 0
        
        // Dealer
        dealerCards = []
        dealerCards.append(deck.drawCard())
        dealerCards.append(deck.drawCard())
        
        gameState = .playerTurn
        message = "Tu turno"
        
        // Check for instant Dealer Blackjack (Usually done if dealer shows Ace/10).
        // For simplicity, we can check basic payouts at the end, but technically dealer BJ ends game immediately.
        // Let's implement check after player turn or if player has BJ.
        
        if initialHand.isBlackjack {
            // Player has Blackjack!
            // If dealer fits rules, they might check.
            // Let's preserve turn for UX unless dealer also has 21.
             HapticManager.shared.playBlackjack()
        }
    }

    // MARK: - Scoring (Static Helper)

    static func calculateScore(of cards: [Card]) -> Int {
        var score = 0
        var aceCount = 0

        for card in cards {
            score += card.rank.value
            if card.rank == .ace { aceCount += 1 }
        }

        while score > 21 && aceCount > 0 {
            score -= 10
            aceCount -= 1
        }

        return score
    }

    // MARK: - Player Actions

    func playerHit() {
        guard gameState == .playerTurn,
              hands.indices.contains(currentHandIndex) else { return }
        
        let newCard = deck.drawCard()
        hands[currentHandIndex].cards.append(newCard)
        
        HapticManager.shared.playSelection()
        
        if hands[currentHandIndex].score > 21 {
            // Bust
            // Bust
            HapticManager.shared.playLoss()
            endCurrentHand()
        }
    }
    
    func playerStand() {
        guard gameState == .playerTurn else { return }
        endCurrentHand()
    }
    
    func playerDouble() {
        guard gameState == .playerTurn,
              hands.indices.contains(currentHandIndex) else { return }
        
        let hand = hands[currentHandIndex]
        
        // Check balance
        if playerBalance >= hand.bet {
            playerBalance -= hand.bet
            hands[currentHandIndex].bet += hand.bet
            hands[currentHandIndex].isDoubled = true
            
            // Draw 1 card only
            let newCard = deck.drawCard()
            hands[currentHandIndex].cards.append(newCard)
            
            HapticManager.shared.playSelection()
            
            // End hand immediately
            endCurrentHand()
        } else {
            message = "Saldo insuficiente para doblar"
            HapticManager.shared.playError()
        }
    }
    
    func playerSplit() {
        guard gameState == .playerTurn,
              hands.indices.contains(currentHandIndex) else { return }
        
        let hand = hands[currentHandIndex]
        
        // Requirement: 2 cards required, same rank (usually value, but strict rules say Rank e.g. two 8s)
        guard hand.cards.count == 2,
              hand.cards[0].rank == hand.cards[1].rank else { return } // Basic check, could compare values too
        
        // Check balance
        if playerBalance >= hand.bet {
            playerBalance -= hand.bet // Deduct splitting bet
            
            // Create two new hands
            let card1 = hand.cards[0]
            let card2 = hand.cards[1]
            
            var hand1 = Hand(bet: hand.bet)
            hand1.cards = [card1]
            // Auto hit for split hand
            hand1.cards.append(deck.drawCard())
            
            var hand2 = Hand(bet: hand.bet)
            hand2.cards = [card2]
            // Auto hit for split hand
            hand2.cards.append(deck.drawCard())
            
            // Check for Split Aces rule: only 1 card allowed. 
            // Simplifying: treat normally for now or just set isDoubled=true to prevent hits?
            // "Al dividir ases solo tendrás derecho a 1 carta añadida" -> auto stand after deal?
            if card1.rank == .ace {
                hand1.isDoubled = true // Hack to prevent hits? Or just mark isCompleted.
                hand1.isCompleted = true
                
                hand2.isDoubled = true
                hand2.isCompleted = true
            }
            
            // Replace current hand with these two
            hands.remove(at: currentHandIndex)
            hands.insert(hand2, at: currentHandIndex)
            hands.insert(hand1, at: currentHandIndex)
            
            // Stay on current index (hand1)
            HapticManager.shared.playSelection()
            
        } else {
            message = "Saldo insuficiente para dividir"
            HapticManager.shared.playError()
        }
    }
    
    /// Avanza a la siguiente mano o al turno del dealer
    private func endCurrentHand() {
        hands[currentHandIndex].isCompleted = true
        
        // Move to next unfinished hand
        if let nextIndex = hands.firstIndex(where: { !$0.isCompleted }) {
            currentHandIndex = nextIndex
        } else {
            // All hands done
            gameState = .dealerTurn
            playDealerTurn()
        }
    }
    
    // MARK: - Dealer Actions
    
    func playDealerTurn() {
        // If all player hands busted, dealer logic might be skipped in some casinos, 
        // but to show dealer score we play it out unless implementation prefers instant loss.
        // Let's play it out.
        
        var score = GameViewModel.calculateScore(of: dealerCards)
        
        func dealerHitRecursive() {
            score = GameViewModel.calculateScore(of: dealerCards)
            
            if score < 17 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let newCard = self.deck.drawCard()
                    self.dealerCards.append(newCard)
                    dealerHitRecursive()
                }
            } else {
                determineWinners()
            }
        }
        
        dealerHitRecursive()
    }
    
    func determineWinners() {
        gameState = .gameOver
        let dealerScore = GameViewModel.calculateScore(of: dealerCards)
        
        var totalWinnings = 0
        
        for index in hands.indices {
            let hand = hands[index]
            let playerScore = hand.score
            
            if playerScore > 21 {
                // Bust - Loss (Bet already taken)
            } else {
                if hand.isBlackjack {
                    // Blackjack pays 3:2
                    if dealerScore == 21 && dealerCards.count == 2 {
                        // Push (Tie) against Dealer Blackjack
                         playerBalance += hand.bet
                    } else {
                        // Win 3:2
                        // Return bet + 1.5x bet
                        let winAmount = Int(Double(hand.bet) * 1.5)
                        playerBalance += hand.bet + winAmount
                        totalWinnings += winAmount
                        // We will play haptic at the end based on total
                    }
                } else if dealerScore > 21 {
                    // Dealer Bust - Win 1:1
                    playerBalance += hand.bet * 2
                    totalWinnings += hand.bet
                } else if playerScore > dealerScore {
                    // Win 1:1
                    playerBalance += hand.bet * 2
                    totalWinnings += hand.bet
                } else if playerScore == dealerScore {
                    // Push - Return Bet
                    playerBalance += hand.bet
                }
                // else Loss
            }
        }
        
        if totalWinnings > 0 {
            message = "¡Ganaste \(totalWinnings)! 🎉"
            // If any hand had BJ, we probably already played it, but let's play win sound if not purely BJ
            // Simplification: Just play win if no BJ played recently? 
            // Better: Play Win.
            HapticManager.shared.playWin()
        } else {
             // Check if all lost (no push, no win)
             // If message says "Ronda terminada", implies no win.
            message = "Ronda terminada"
            // Only play loss if player actually lost money?
             HapticManager.shared.playLoss()
        }
    }
}

