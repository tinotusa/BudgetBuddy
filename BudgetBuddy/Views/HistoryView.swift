//
//  HistoryView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \BudgetItem.name, ascending: true)])
    var budgetItems: FetchedResults<BudgetItem>
   
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(alignment: .leading) {
                title
                MonthlyTotalBarChart()
                    .card()
                    .frame(height: 400)
                    .foregroundColor(.white)
                recent
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

private extension HistoryView {
    var title: some View {
        Text("History")
            .foregroundColor(.white)
            .font(.largeTitle)
    }
    var recent: some View {
        Text("hello there")
            .card()
            .frame(height: 200)
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(
                \.managedObjectContext,
                 PersistenceController.shared.container.viewContext
            )
    }
}
