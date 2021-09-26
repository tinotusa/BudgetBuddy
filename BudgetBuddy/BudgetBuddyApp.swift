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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
                .environmentObject(userModel)
        }
    }
}
