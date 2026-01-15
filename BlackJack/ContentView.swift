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
                gradient: Gradient(colors: [Color("TableGreenLight", bundle: nil), Color("TableGreenDark", bundle: nil)]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top Bar: Balance
                HStack {
                    Text("Saldo: $\(viewModel.playerBalance)")
                        .font(.headline)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.yellow)
                        .cornerRadius(10)
                    
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
                .font(.system(size: 60, weight: .heavy, design: .serif))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            Text("Apuesta Actual: $\(viewModel.currentBet)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("Selecciona Fichas")
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 15) {
                    chipButton(amount: 50, color: .red)
                    chipButton(amount: 100, color: .blue)
                    chipButton(amount: 500, color: .green)
                    chipButton(amount: 1000, color: .black)
                }
                
                HStack(spacing: 30) {
                    Button(action: { viewModel.clearBet() }) {
                        Text("BORRAR")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        withAnimation { viewModel.deal() }
                    }) {
                        Text("REPARTIR")
                            .fontWeight(.bold)
                            .padding()
                            .frame(minWidth: 150)
                            .background(viewModel.currentBet >= 50 ? Color.yellow : Color.gray.opacity(0.5))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.currentBet < 50)
                }
                .padding(.top, 20)
            }
            .padding(.bottom, 50)
            
            // Error overlay
            Text(viewModel.message)
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func chipButton(amount: Int, color: Color) -> some View {
        Button(action: {
            viewModel.placeBet(amount: amount)
        }) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2).padding(2))
                    .shadow(radius: 3)
                
                Text("\(amount)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Gameplay View
    
    var gameplayView: some View {
        VStack {
            // Dealer Area
            VStack(spacing: 5) {
                Text("DEALER")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: -30) {
                    ForEach(Array(viewModel.dealerCards.enumerated()), id: \.offset) { index, card in
                        if index == 1 && (viewModel.gameState == .playerTurn) {
                            CardBackView()
                                .transition(.asymmetric(insertion: .scale, removal: .scale))
                        } else {
                            CardView(card: card)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        }
                    }
                }
                .frame(height: 120)
                
                if viewModel.gameState == .gameOver {
                    Text("\(GameViewModel.calculateScore(of: viewModel.dealerCards))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 10)
            
            Spacer()
            
            // Hands Message
            if viewModel.hands.count > 1 {
                Text(viewModel.gameState == .playerTurn ? "Mano \(viewModel.currentHandIndex + 1) de \(viewModel.hands.count)" : "Resultados")
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            
            // Player Hands Area
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(viewModel.hands.enumerated()), id: \.element.id) { index, hand in
                        PlayerHandView(hand: hand, isActive: index == viewModel.currentHandIndex && viewModel.gameState == .playerTurn)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Message
            if viewModel.isGameOver {
                Text(viewModel.message)
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .transition(.scale)
            }
            
            // Controls
            if viewModel.gameState == .playerTurn {
                controlButtons
            } else if viewModel.gameState == .gameOver {
                Button(action: {
                    withAnimation { viewModel.startBettingPhase() }
                }) {
                    Text("NUEVA RONDA")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    var controlButtons: some View {
        VStack {
            HStack(spacing: 20) {
                // SPLIT
                Button(action: {
                    withAnimation { viewModel.playerSplit() }
                }) {
                    VStack {
                        Image(systemName: "arrow.branch")
                        Text("DIVIDIR")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!(viewModel.currentHand?.cards.count == 2 && viewModel.currentHand?.cards[0].rank == viewModel.currentHand?.cards[1].rank))
                .opacity((viewModel.currentHand?.cards.count == 2 && viewModel.currentHand?.cards[0].rank == viewModel.currentHand?.cards[1].rank) ? 1.0 : 0.5)
                
                // HIT
                Button(action: {
                    withAnimation { viewModel.playerHit() }
                }) {
                    Text("PEDIR")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                // STAND
                Button(action: {
                    withAnimation { viewModel.playerStand() }
                }) {
                    Text("PLANTARSE")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                // DOUBLE
                Button(action: {
                    withAnimation { viewModel.playerDouble() }
                }) {
                    VStack {
                        Image(systemName: "xmark.circle")
                        Text("DOBLAR")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.currentHand?.cards.count != 2) // Can double on any 2 cards usually
                .opacity(viewModel.currentHand?.cards.count == 2 ? 1.0 : 0.5)
            }
            .padding(.bottom, 20)
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
