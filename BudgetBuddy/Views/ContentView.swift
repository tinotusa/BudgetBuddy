//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("someStore") var hasUser: Bool = false
    
    var body: some View {
        NavigationView {
            if hasUser {
                HomeView()
            } else {
                LoginView(hasUser: $hasUser)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(
                \.managedObjectContext,
                 PersistenceController.shared.container.viewContext
            )
            .environmentObject(UserModel())
    }
}
