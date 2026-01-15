import SwiftUI

struct EditBalanceView: View {
    @Environment(\.dismiss) var dismiss
    let currentBalance: Int
    var onSave: (Int) -> Void
    
    @State private var balanceInput: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Modificar Saldo")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("NUEVO SALDO")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("0", text: $balanceInput)
                        .keyboardType(.numberPad)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .focused($isInputFocused)
                        .onAppear {
                            balanceInput = String(currentBalance)
                            isInputFocused = true
                        }
                    
                    if !balanceInput.isEmpty {
                        Button(action: { balanceInput = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            HStack(spacing: 20) {
                Button(action: { dismiss() }) {
                    Text("Cancelar")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    if let newBalance = Int(balanceInput) {
                        onSave(newBalance)
                        dismiss()
                    }
                }) {
                    Text("Guardar")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .disabled(Int(balanceInput) == nil)
                .opacity(Int(balanceInput) == nil ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .presentationDetents([.height(300)]) // Make it a bottom sheet of fixed height
        .presentationDragIndicator(.visible)
    }
}
