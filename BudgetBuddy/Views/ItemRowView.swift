//
//  ItemRowView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI


struct ItemRowView: View {
    /// The Item being displayed.
    let item: BudgetItem
    
    /// The size of the icons.
    private let size = 80.0
    
    /// Some default image names for some generic buget item names.
    private let defaultIcons = ["spotify", "netflix"]
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack {
                icon
                
                VStack(alignment: .leading) {
                    Text(item.wrappedName)
                        .font(.title)
                    if item.isSubscription {
                        Text("Next payment: \(item.wrappedNextPayDate.formatted(date: .numeric, time: .omitted))")
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                Text(item.amount.currencyString)
                    .font(.title)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
        }
        .foregroundColor(.white)
    }
    
    /// The icon representing the buget item.
    private var icon: some View {
        Group {
            if defaultIcons.contains(item.wrappedName.lowercased()) {
                Image(item.wrappedName.lowercased())
                    .resizable()
                    .scaledToFit()
            } else {
                // TODO: - find something else to put here
                Color.red.opacity(0.5)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static let item = { () -> BudgetItem in
        let item = BudgetItem(context: context)
        item.id = UUID()
        item.name = "Netflix"
        item.amount = 100
        item.isSubscription = true
        item.nextPayDate = Date()
        item.dateAdded = Date()

        return item
    }()
    
    static var previews: some View {
        ItemRowView(item: item)
            .background(.blue.opacity(0.5))
            .previewLayout(.fixed(width: 450, height: 100))
            
    }
}
