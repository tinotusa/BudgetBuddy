//
//  LoginView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI

struct LoginView: View {
    @State private var name = ""
    @State private var balance = ""
    @EnvironmentObject var userModel: UserModel
    
    @Binding var hasUser: Bool
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .disableAutocorrection(true)
            
            TextField("Balance", text: $balance)
                .keyboardType(.decimalPad)
            
            Button(action: addUser) {
                Text("Create User")
                    .frame(width: 200)
            }
            .disabled(!allFieldsFilled)
            .controlSize(.large)
            .buttonStyle(.bordered)
            .tint(.blue)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

private extension LoginView {
    var allFieldsFilled: Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let balance = balance.trimmingCharacters(in: .whitespacesAndNewlines)
        if Double(balance) == nil {
            return false
        }
        return !name.isEmpty && !balance.isEmpty
    }
    
    func addUser() {
        let balance = Double(balance) ?? 0
        userModel.name = name
        userModel.balance = balance
        hasUser = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(hasUser: .constant(false))
            .environmentObject(UserModel())
    }
}
