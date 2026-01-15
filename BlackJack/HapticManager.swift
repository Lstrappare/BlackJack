//
//  HapticManager.swift
//  BlackJack
//
//  Created by Jose Cisneros on 15/01/26.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // Feedback Generators
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    /// Prepara los generadores para reducir la latencia
    func prepare() {
        selectionGenerator.prepare()
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
    }
    
    // MARK: - Specific Actions
    
    /// Vibración para cuando se coloca una ficha (Toque firme)
    func playChipPlacement() {
        impactMedium.impactOccurred()
    }
    
    /// Vibración simple de selección (Botones)
    func playSelection() {
        selectionGenerator.selectionChanged()
    }
    
    /// Vibración para victoria estándar
    func playWin() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    /// Vibración para derrota
    func playLoss() {
        notificationGenerator.notificationOccurred(.error)
    }
    
    /// Vibración especial para Blackjack (Secuencia)
    func playBlackjack() {
        // Secuencia distintiva: Impacto fuerte -> breve pausa -> Éxito
        impactHeavy.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.notificationGenerator.notificationOccurred(.success)
        }
        
        // Opcional: Una segunda pulsación para énfasis
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
             self.impactMedium.impactOccurred()
        }
    }
    
    /// Vibración para error general (Saldo insuficiente, etc.)
    func playError() {
        notificationGenerator.notificationOccurred(.error)
    }
}
