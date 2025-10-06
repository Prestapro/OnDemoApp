import SwiftUI

struct PersonalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileManager = UserProfileManager.shared
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var membershipType: MembershipType = .premium
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Details") {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Enter name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Enter email", text: $email)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    HStack {
                        Text("Phone")
                        Spacer()
                        TextField("Enter phone", text: $phone)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.phonePad)
                    }
                }
                
                Section("Address") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Address")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("Enter address", text: $address, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                
                Section("Membership") {
                    Picker("Membership Type", selection: $membershipType) {
                        ForEach(MembershipType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Personal Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadCurrentValues()
        }
    }
    
    private func loadCurrentValues() {
        name = userProfileManager.profile.name
        email = userProfileManager.profile.email
        phone = userProfileManager.profile.phone
        address = userProfileManager.profile.address
        membershipType = userProfileManager.profile.membershipType
    }
    
    private func saveChanges() {
        userProfileManager.updateProfile(
            name: name,
            email: email,
            phone: phone,
            address: address
        )
        userProfileManager.profile.membershipType = membershipType
        userProfileManager.saveProfile()
        dismiss()
    }
}

struct PersonalInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInformationView()
    }
}