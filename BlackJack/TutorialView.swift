import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.2, blue: 0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Objetivo
                        SectionView(title: "Objetivo del Juego", icon: "flag.fill") {
                            Text("El objetivo es sumar **21** o acercarse lo más posible sin pasarse. Debes superar al dealer para ganar.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Valor de las cartas
                        SectionView(title: "Valor de las Cartas", icon: "suit.club.fill") {
                            VStack(spacing: 15) {
                                ValueRow(card: Card(rank: .seven, suit: .diamonds), description: "Valen su número (2-9).")
                                ValueRow(card: Card(rank: .king, suit: .clubs), description: "J, Q, K valen 10.")
                                ValueRow(card: Card(rank: .ace, suit: .hearts), description: "As vale 1 u 11.")
                            }
                        }
                        
                        // Acciones
                        SectionView(title: "Acciones", icon: "hand.tap.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                ActionRow(icon: "plus.circle.fill", color: .green, title: "Pedir (Hit)", description: "Toma otra carta.")
                                ActionRow(icon: "hand.raised.fill", color: .red, title: "Plantarse (Stand)", description: "Quédate con tu mano.")
                                ActionRow(icon: "xmark.circle.fill", color: .orange, title: "Doblar (Double)", description: "Dobla apuesta, recibe 1 carta.")
                                ActionRow(icon: "arrow.triangle.branch", color: .blue, title: "Dividir (Split)", description: "Divide un par en dos manos independientes.")
                            }
                        }
                        
                        // Dealer
                        SectionView(title: "Reglas del Dealer", icon: "person.fill") {
                            Text("El dealer **debe pedir** con 16 o menos y **plantarse** con 17 o más. Si se pasa de 21, ¡ganas!")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Reglas del Blackjack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

struct SectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.yellow)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            content
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct ValueRow: View {
    let card: Card
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            CardView(card: card)
                .scaleEffect(0.625)
                .frame(width: 50, height: 75)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct ActionRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(color)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    TutorialView()
}
