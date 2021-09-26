//
//  AddView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI
import CoreData

struct AddView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserModel
    @AppStorage("hasUser") var hasUser = false
    
    @State private var name = ""
    @State private var amount = ""
    @State private var isSubscription = false
    @State private var subcriptionType = SubscriptionType.monthly
    @State private var itemType = ItemType.expense
    
    
    enum SubscriptionType: String, CaseIterable, Identifiable{
        case weekly, monthly, annually
        var id: Self {
            self
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item type")) {
                    Picker("Item type", selection: $itemType.animation()) {
                        ForEach(ItemType.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if itemType == .income {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                } else {
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
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
        if itemType == .income {
            return !amount.isEmpty
        }
        return !name.isEmpty && !amount.isEmpty
    }
    
    
    private func addBudgetItem() {
        defer {
            saveContext(context: context)
            dismiss()
        }
        let item = BudgetItem(context: context)
        item.id = UUID()
        item.wrappedType = itemType
        if item.wrappedType == .income {
            item.name = "Income"
        } else {
            item.name = name
        }
        item.amount = Double(amount) ?? 0
        
        // TODO: - maybe have an array of items in the user?
        switch item.wrappedType {
        case .expense:
            userModel.spending += item.amount
        case .income:
            userModel.income += item.amount
        }

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
    }
}

func saveContext(context: NSManagedObjectContext) {
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


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
