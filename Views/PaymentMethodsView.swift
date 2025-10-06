import SwiftUI

struct PaymentMethodsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileManager = UserProfileManager.shared
    @State private var showingAddPayment = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(userProfileManager.paymentMethods.enumerated()), id: \.element.id) { index, method in
                    PaymentMethodRowView(
                        method: method,
                        isDefault: method.isDefault,
                        onSetDefault: {
                            userProfileManager.setDefaultPaymentMethod(at: index)
                        },
                        onDelete: {
                            userProfileManager.removePaymentMethod(at: index)
                        }
                    )
                }
                
                Button(action: {
                    showingAddPayment = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                        Text("Add Payment Method")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddPayment) {
                AddPaymentMethodView()
            }
        }
    }
}

struct PaymentMethodRowView: View {
    let method: PaymentMethod
    let isDefault: Bool
    let onSetDefault: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(method.maskedCardNumber)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(method.cardholderName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Expires \(method.expiryDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    if isDefault {
                        Text("DEFAULT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    } else {
                        Button("Set Default") {
                            onSetDefault()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .contextMenu {
            if !isDefault {
                Button("Set as Default") {
                    onSetDefault()
                }
            }
            
            Button("Delete", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .alert("Delete Payment Method", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this payment method?")
        }
    }
}

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileManager = UserProfileManager.shared
    @State private var cardNumber: String = ""
    @State private var cardholderName: String = ""
    @State private var expiryDate: String = ""
    @State private var isDefault: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Card Information") {
                    HStack {
                        Text("Card Number")
                        Spacer()
                        TextField("1234 5678 9012 3456", text: $cardNumber)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Cardholder Name")
                        Spacer()
                        TextField("John Doe", text: $cardholderName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Expiry Date")
                        Spacer()
                        TextField("MM/YY", text: $expiryDate)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section {
                    Toggle("Set as Default", isOn: $isDefault)
                }
            }
            .navigationTitle("Add Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePaymentMethod()
                    }
                    .fontWeight(.semibold)
                    .disabled(cardNumber.isEmpty || cardholderName.isEmpty || expiryDate.isEmpty)
                }
            }
        }
    }
    
    private func savePaymentMethod() {
        let newMethod = PaymentMethod(
            cardNumber: cardNumber,
            cardholderName: cardholderName,
            expiryDate: expiryDate,
            isDefault: isDefault
        )
        
        userProfileManager.addPaymentMethod(newMethod)
        dismiss()
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView()
    }
}