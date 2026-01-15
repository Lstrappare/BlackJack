import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Objetivo del Juego")
                            .font(.title2)
                            .bold()
                        Text("El objetivo del Blackjack es conseguir una mano con un valor total lo más cercano posible a 21, sin pasarse. Debes tener una puntuación mayor que la del dealer para ganar.")
                    }
                    
                    Group {
                        Text("Valor de las Cartas")
                            .font(.title2)
                            .bold()
                        Text("• Cartas numéricas (2-10): Valen su número.")
                        Text("• Figuras (J, Q, K): Valen 10.")
                        Text("• As (A): Vale 1 u 11, lo que más te beneficie.")
                    }
                    
                    Group {
                        Text("Acciones")
                            .font(.title2)
                            .bold()
                        Text("• Hit (Pedir): Pides una carta adicional.")
                        Text("• Stand (Plantarse): Te quedas con tu mano actual.")
                        Text("• Double (Doblar): Doblas tu apuesta inicial y recibes una sola carta más.")
                    }
                    
                    Group {
                        Text("Reglas del Dealer")
                            .font(.title2)
                            .bold()
                        Text("El dealer debe pedir cartas hasta que su total sea 17 o más. Si el dealer se pasa de 21, tú ganas (si no te has pasado tú también).")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("Reglas del Blackjack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TutorialView()
}
