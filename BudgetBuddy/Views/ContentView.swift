//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("someStore") var hasUser: Bool = false
    enum Tab {
        case home, history
    }
    @State private var selectedTab = Tab.home
    
    var body: some View {
        if hasUser {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "chart.line.uptrend.xyaxis")
                    }
            }
        } else {
            LoginView(hasUser: $hasUser)
        }
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
