//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//

import SwiftUI

struct ContentView: View {
    enum Tab: String, CaseIterable, Identifiable {
        case home = "house"
        case history = "chart.line.uptrend.xyaxis"
        
        var id: Self {
            self
        }
        
    }
    
    @State private var selectedTab = Tab.home
    @State private var showingAddSheet = false

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    HomeView().tag(Tab.home)
                    HistoryView().tag(Tab.history)
                }
                tabIcons
                
            }
            .sheet(isPresented: $showingAddSheet) {
                AddView()
        }
            floatingAddButton
        }
    }
}

private extension ContentView {
    var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("lightBlue"))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    var tabIcons: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                GeometryReader { proxy in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        VStack {
                            Image(systemName: tab.rawValue)
                                .font(.largeTitle)
                                .frame(width: 50, height: 50)
                            if tab == selectedTab {
                                Rectangle()
                                    .frame(width: 70, height: 2)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: 50)
        .background(Color("lightBlue"))
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
