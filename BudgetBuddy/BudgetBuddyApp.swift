//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//

import SwiftUI

@main
struct BudgetBuddyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var userModel = UserModel()
    @AppStorage("hasUser") var hasUser: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !hasUser {
                LoginView(hasUser: $hasUser)
                    .environmentObject(userModel)
            } else {
                ContentView()
                    .environment(
                        \.managedObjectContext,
                         persistenceController.container.viewContext
                    )
                    .environmentObject(userModel)
            }
        }
    }
}
