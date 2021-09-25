//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//

import SwiftUI
import CoreData

struct AddView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = ""
    @State private var isSubscription = false
    @State private var subcriptionType = SubscriptionType.monthly

    
    enum SubscriptionType: String, CaseIterable, Identifiable{
        case weekly, monthly, annually
        var id: Self {
            self
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                Toggle("Subscription", isOn: $isSubscription)
                if isSubscription {
                    Picker("Subscription payment model", selection: $subcriptionType) {
                        ForEach(SubscriptionType.allCases) { subscription in
                            Text(subscription.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Button(action: addBudgetItem) {
                    Text("Add")
                }
                .disabled(!importantFieldsFilled)
                .buttonStyle(.bordered)
                .tint(.blue)
            }
            .navigationTitle("Add item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addBudgetItem) {
                        Text("Add")
                    }
                    .disabled(!importantFieldsFilled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var importantFieldsFilled: Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let amount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let _ = Double(amount) else { return false }
        return !name.isEmpty && !amount.isEmpty
    }
    
    
    private func addBudgetItem() {
        defer { dismiss() }
        let item = BudgetItem(context: context)
        item.id = UUID()
        item.name = name
        item.amount = Double(amount) ?? 0
        item.dateAdded = Date()
        item.isSubscription = isSubscription
        
        if item.isSubscription {
            var dateComponents = DateComponents(calendar: Calendar.current)
            
            switch subcriptionType {
            case .weekly:
                dateComponents.day = 7
                let futureDate = Calendar.current.date(byAdding: dateComponents, to: item.dateAdded!)
                item.nextPayDate = futureDate
            case .monthly:
                dateComponents.month = 1
                let futureDate = Calendar.current.date(byAdding: dateComponents, to: item.dateAdded!)
                item.nextPayDate = futureDate
            case .annually:
                dateComponents.year = 1
                let futureDate = Calendar.current.date(byAdding: dateComponents, to: item.dateAdded!)
                item.nextPayDate = futureDate
            }
        }
        saveContext(context: context)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [])
    var budgetItems: FetchedResults<BudgetItem>
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(budgetItems) { budgetItem in
                        HStack {
                            Color.red.opacity(0.6)
                                .frame(width: 80, height: 80)
                                .mask(RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading) {
                                Text(budgetItem.name ?? "No name")
                                    .font(.title2)
                                if budgetItem.isSubscription {
                                    Text("Next payment: \(formattedDate(budgetItem.wrappedNextPayDate))")
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            Text("\(budgetItem.amount.formatted(.currency(code: "AUD")))")
                                .font(.title)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                
                Button{
                    showingAddSheet = true
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

private extension ContentView {
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/y"
        return formatter.string(from: date)
    }
    
    func deleteAll() {
        budgetItems.forEach { item in
            context.delete(item)
        }
        saveContext(context: context)
    }
    
    func delete(offsets: IndexSet) {
        offsets.map { budgetItems[$0] }
        .forEach { item in
            context.delete(item)
        }
        saveContext(context: context)
    }
}

private func saveContext(context: NSManagedObjectContext) {
    if !context.hasChanges {
        return
    }
    do {
        try withAnimation {
            try context.save()
        }
    } catch let error as NSError {
        fatalError("Error when saving context. Error: \(error.userInfo)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(
                \.managedObjectContext,
                 PersistenceController.shared.container.viewContext)
    }
}
