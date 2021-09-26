//
//  HomeView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \BudgetItem.dateAdded, ascending: true)])
    var budgetItems: FetchedResults<BudgetItem>

    @State private var showingAddSheet = false
    @EnvironmentObject var userModel: UserModel
    
    let defaultIcons = ["Spotify", "Netflix"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("name: \(userModel.name)")
                Text("balance: \(userModel.balance)")
                Text("income: \(userModel.income)")
                Text("expense: \(userModel.spending)")
                List {
                    ForEach(budgetItems) { budgetItem in
                        HStack {
                            if defaultIcons.contains(budgetItem.wrappedName) {
                                Image(budgetItem.wrappedName.lowercased())
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .scaledToFill()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else {
                                Color.red.opacity(0.6)
                                    .frame(width: 80, height: 80)
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            VStack(alignment: .leading) {
                                Text(budgetItem.name ?? "No name")
                                    .font(.title2)
                                if budgetItem.isSubscription {
                                    Text("Next payment: \(formattedDate(budgetItem.wrappedNextPayDate))")
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            Text("\(budgetItem.amount.formatted(.currency(code: locale)))")
                                .font(.title)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)

                Button{
                    // TODO: UNCOMMENT ME
                     showingAddSheet = true
                    
//                    addRandomEntries(1000)
                } label: {
                    Text("Add")
                        .frame(width: 300)
                }
                .controlSize(.large)
                .buttonStyle(.bordered)
                .tint(.blue)
            }
            .navigationTitle("Testing")
            .sheet(isPresented: $showingAddSheet) {
                AddView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete all", role: .destructive, action: deleteAll)
                }
        }
        }
    }
}

private extension HomeView {
    var locale: String {
        Locale.current.currencyCode ?? "AUD"
    }
    
    func addRandomEntries(_ amount: Int) {
        for _ in 0..<amount {
            let item = BudgetItem(context: context)
            item.id = UUID()
            item.name = "test"
            item.amount = Double.random(in: 1..<200)
            item.isSubscription = Bool.random()
            let components = DateComponents(
                calendar: .current,
                year: 2021,
                month: Int.random(in: 1..<12),
                day: Int.random(in: 1..<28)
            )
            item.dateAdded = Calendar.current.date(from: components)
            item.type = Bool.random() ? ItemType.expense.rawValue : ItemType.income.rawValue
            
            saveContext(context: context)
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/y"
        return formatter.string(from: date)
    }
    
    func deleteAll() {
        budgetItems.forEach { item in
            userModel.delete(item)
            context.delete(item)
        }
        saveContext(context: context)
    }
    
    func delete(offsets: IndexSet) {
        offsets.map { budgetItems[$0] }
        .forEach { item in
            userModel.delete(item)
            context.delete(item)
        }
        saveContext(context: context)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserModel())
    }
}
