//
//  ContentView.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            // Background
            RadialGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.2), Color.black]),
                center: .center,
                startRadius: 50,
                endRadius: 600
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top Bar: Balance
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                        Text("\(viewModel.playerBalance)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.black.opacity(0.8)))
                    .overlay(Capsule().stroke(Color.yellow.opacity(0.5), lineWidth: 1))
                    .shadow(radius: 5)
                    
                    Spacer()
                }
                .padding()
                
                if viewModel.gameState == .betting {
                    bettingView
                } else {
                    gameplayView
                }
            }
        }
    }
    
    // MARK: - Betting View
    
    var bettingView: some View {
        VStack {
            Spacer()
            
            Text("BLACKJACK")
                .font(.system(size: 50, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                .padding(.bottom, 5)
            
            Text("Apuesta Actual")
                .font(.subheadline)
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .kerning(2)
            
            Text("$\(viewModel.currentBet)")
                .font(.system(size: 60, weight: .thin, design: .default))
                .foregroundColor(.white)
                .padding(.bottom, 30)
            
            Spacer()
            
            VStack(spacing: 25) {
                Text("SELECCIONA TUS FICHAS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.6))
                    .kerning(1)
                
                HStack(spacing: 20) {
                    chipButton(amount: 50, color: .red)
                    chipButton(amount: 100, color: .blue)
                    chipButton(amount: 500, color: .green)
                    chipButton(amount: 1000, color: .orange)
                }
                
                HStack(spacing: 20) {
                    Button(action: { viewModel.clearBet() }) {
                        Text("BORRAR")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        withAnimation { viewModel.deal() }
                    }) {
                        Text("REPARTIR")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .top, endPoint: .bottom)
                            )
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .disabled(viewModel.currentBet < 50)
                    .opacity(viewModel.currentBet < 50 ? 0.5 : 1.0)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }
            .padding(.bottom, 50)
            
            // Error overlay
            if !viewModel.message.isEmpty && viewModel.gameState == .betting {
                Text(viewModel.message)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    func chipButton(amount: Int, color: Color) -> some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            viewModel.placeBet(amount: amount)
        }) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [color.opacity(0.8), color]), center: .center, startRadius: 0, endRadius: 35)
                    )
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 4)
                    )
                    .overlay(
                         Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                     )
                    .shadow(color: color.opacity(0.4), radius: 5, x: 0, y: 3)
                
                Text("\(amount)")
                    .font(.callout)
                    .fontDesign(.rounded)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
            }
        }
    }
    
    // MARK: - Gameplay View
    
    var gameplayView: some View {
        VStack {
            // Dealer Area
            VStack(spacing: 10) {
                Text("DEALER")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.5))
                    .kerning(1)
                
                ZStack {
                    HStack(spacing: -40) {
                        ForEach(Array(viewModel.dealerCards.enumerated()), id: \.offset) { index, card in
                            if index == 1 && (viewModel.gameState == .playerTurn) {
                                CardBackView()
                                    .transition(.asymmetric(insertion: .scale, removal: .scale))
                                    .rotationEffect(.degrees(Double(index) * 2))
                            } else {
                                CardView(card: card)
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                                    .rotationEffect(.degrees(Double(index) * 2))
                            }
                        }
                    }
                }
                .frame(height: 120)
                
                if viewModel.gameState == .gameOver {
                    HStack {
                        Text("Puntuación:")
                            .foregroundColor(.gray)
                        Text("\(GameViewModel.calculateScore(of: viewModel.dealerCards))")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .font(.subheadline)
                    .padding(8)
                    .background(Capsule().fill(Color.black.opacity(0.6)))
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Hands Message
            if viewModel.hands.count > 1 {
                Text(viewModel.gameState == .playerTurn ? "TU TURNO: MANO \(viewModel.currentHandIndex + 1)" : "RESULTADOS")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.bottom, 5)
            }
            
            // Player Hands Area
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(viewModel.hands.enumerated()), id: \.element.id) { index, hand in
                        PlayerHandView(hand: hand, isActive: index == viewModel.currentHandIndex && viewModel.gameState == .playerTurn)
                            .scaleEffect(index == viewModel.currentHandIndex && viewModel.gameState == .playerTurn ? 1.05 : 1.0)
                            .animation(.spring(), value: viewModel.currentHandIndex)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Message Overlay
            if viewModel.isGameOver {
                VStack(spacing: 10) {
                    Text(viewModel.message)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    if viewModel.message.contains("GANASTE") {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.85))
                .cornerRadius(15)
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Controls
            ZStack {
                if viewModel.gameState == .playerTurn {
                    controlButtons
                        .transition(.move(edge: .bottom))
                } else if viewModel.gameState == .gameOver {
                    Button(action: {
                        withAnimation { viewModel.startBettingPhase() }
                    }) {
                        Text("NUEVA RONDA")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .shadow(color: .yellow.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: viewModel.gameState)
        }
    }
    
    var controlButtons: some View {
        VStack {
            HStack(spacing: 15) {
                // SPLIT
                if (viewModel.currentHand?.cards.count == 2 && viewModel.currentHand?.cards[0].rank == viewModel.currentHand?.cards[1].rank) {
                     actionButton(title: "DIVIDIR", icon: "arrow.branch", color: .purple) {
                         withAnimation { viewModel.playerSplit() }
                     }
                }
                
                // DOUBLE
                if viewModel.currentHand?.cards.count == 2 {
                    actionButton(title: "DOBLAR", icon: "xmark.circle", color: .pink) {
                         withAnimation { viewModel.playerDouble() }
                    }
                }
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 20) {
                // STAND
                Button(action: {
                    withAnimation { viewModel.playerStand() }
                }) {
                    Text("PLANTARSE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(minWidth: 140)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                
                // HIT
                Button(action: {
                    withAnimation { viewModel.playerHit() }
                }) {
                    Text("PEDIR")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(minWidth: 140)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .frame(width: 80, height: 60)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 2)
            )
            .cornerRadius(12)
        }
    }

}

// Subview para mostrar una mano individual
struct PlayerHandView: View {
    let hand: Hand
    let isActive: Bool
    
    var body: some View {
        VStack {
            // Cards
            HStack(spacing: -30) {
                ForEach(hand.cards) { card in
                    CardView(card: card)
                        .transition(.scale)
                }
            }
            .frame(height: 120)
            .opacity(hand.isCompleted && !isActive ? 0.6 : 1.0) // Dim completed hands
            
            // Info
            HStack {
                Text("$\(hand.bet)")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    
                Text("\(hand.score)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .stroke(isActive ? Color.yellow : Color.white.opacity(0.3), lineWidth: isActive ? 3 : 1)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    )
            }
            
            if hand.isDoubled {
                Text("DOBLADO")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(isActive ? Color.white.opacity(0.1) : Color.clear)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isActive ? Color.yellow.opacity(0.7) : Color.clear, lineWidth: 2)
        )
    }
}

