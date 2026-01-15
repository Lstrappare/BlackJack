//
//  ContentView.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI

/// Vista principal del juego de Blackjack.
///
/// Esta vista se encarga únicamente de la presentación:
/// - Muestra las cartas del dealer y del jugador
/// - Presenta el puntaje actual del jugador
/// - Expone los controles de interacción (pedir carta, reiniciar)
///
/// Toda la lógica y el estado del juego se delegan al `GameViewModel`,
/// siguiendo el patrón MVVM.
struct ContentView: View {
    
    // MARK: - ViewModel
    
    /// ViewModel que administra la lógica y el estado del juego.
    ///
    /// `@StateObject` indica que esta vista es la propietaria
    /// del ciclo de vida del ViewModel.
    @StateObject var viewModel = GameViewModel()
    
    // MARK: - View Body
    
    var body: some View {
        ZStack {
            
            // Background: Felt table effect
            RadialGradient(
                gradient: Gradient(colors: [Color("TableGreenLight", bundle: nil), Color("TableGreenDark", bundle: nil)]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // MARK: - Dealer Section
                
                VStack(spacing: 10) {
                    Text("DEALER")
                        .font(.custom("CourierNew-Bold", size: 18))
                        .foregroundColor(Color.white.opacity(0.7))
                        .tracking(2)
                    
                    HStack(spacing: -30) {
                        ForEach(viewModel.dealerCards) { card in
                            CardView(card: card)
                                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                        }
                    }
                    .frame(height: 120)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // MARK: - Score Badge
                
                Text("\(viewModel.calculateScore(of: viewModel.playerCards))")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Circle().stroke(Color.white.opacity(0.3), lineWidth: 4))
                    .shadow(radius: 10)
                
                Spacer()
                
                // MARK: - Message Overlay
                if viewModel.isGameOver {
                    Text(viewModel.message)
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .transition(.scale)
                        .padding()
                }
                
                // MARK: - Player Section
                
                VStack(spacing: 10) {
                    Text("JUGADOR")
                        .font(.custom("CourierNew-Bold", size: 18))
                        .foregroundColor(Color.white.opacity(0.7))
                        .tracking(2)
                    
                    HStack(spacing: -30) {
                        ForEach(viewModel.playerCards) { card in
                            CardView(card: card)
                                .transition(.offset(y: 200).combined(with: .opacity))
                        }
                    }
                    .frame(height: 120)
                }
                .padding(.bottom, 20)
                
                // MARK: - Controls
                
                HStack(spacing: 40) {
                    
                    // Hit Button
                    Button(action: {
                        withAnimation {
                            viewModel.playerHit()
                        }
                    }) {
                        Text("PEDIR")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: Color.blue.opacity(0.5), radius: 5, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .disabled(viewModel.isGameOver)
                    .opacity(viewModel.isGameOver ? 0.6 : 1.0)
                    
                    // Restart Button
                    Button(action: {
                        withAnimation {
                            viewModel.startGame()
                        }
                    }) {
                        Text("REINICIAR")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 40)
            }
        }
        // Inicia automáticamente una nueva partida al aparecer la vista
        .onAppear {
            viewModel.startGame()
        }
    }
}
