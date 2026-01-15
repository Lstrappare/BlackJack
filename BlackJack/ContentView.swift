//
//  ContentView.swift
//  BlackJack
//
//  Created by Jose Cisneros on 14/01/26.
//

import SwiftUI

/// Vista principal del juego.
/// La lógica y el estado del juego se delegan al `GameViewModel`.
struct ContentView: View {

    // MARK: - ViewModel

    /// ViewModel que controla el estado y la lógica del juego.
    ///
    /// `@StateObject` indica que esta vista es la dueña del ciclo de vida
    /// del ViewModel.
    @StateObject var viewModel = GameViewModel()

    // MARK: - View Body

    var body: some View {
        ZStack {

            // Fondo principal tipo casino
            Color.green
                .edgesIgnoringSafeArea(.all)

            VStack {

                // MARK: Dealer Section

                /// Sección que muestra las cartas del dealer (la casa)
                Text("Dealer")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack {
                    ForEach(viewModel.dealerCards) { card in
                        Text(card.displayTitle)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                }
                .padding()

                Spacer()

                // MARK: Score Section

                /// Marcador que muestra el puntaje actual del jugador
                Text("Puntaje: \(viewModel.calculateScore(of: viewModel.playerCards))")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()

                Spacer()

                // MARK: Player Section

                /// Sección que muestra las cartas del jugador
                Text("Tú")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack {
                    ForEach(viewModel.playerCards) { card in
                        Text(card.displayTitle)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                }
                .padding()

                // MARK: Controls

                /// Controles principales del juego
                HStack(spacing: 50) {

                    Button("Pedir") {
                        //TODO:  Acción para pedir carta (definida en el ViewModel)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Reiniciar") {
                        viewModel.startGame()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        // Inicia automáticamente una nueva partida al mostrar la vista
        .onAppear {
            viewModel.startGame()
        }
    }
}
