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
                piechart
                    .card()
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
    
    var piechart: some View {
        HStack {
            PieChartView(
                data: data,
                labels: labels,
                colours: colours,
                labelOffset: 20.0
            )
                
            Spacer()
            
            VStack(alignment: .leading) {
                // TODO: - find a less brittle way to do this
                pieChartLegend(colour: colours[0], label: labels[0])
                pieChartLegend(colour: colours[1], label: labels[1])
                pieChartLegend(colour: colours[2], label: labels[2])
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .frame(height: 200)
    }
    
    func pieChartLegend(colour: Color, label: String) -> some View {
        HStack {
            colour
                .frame(width: 20, height: 20)
            Text(label)
        }
    }
    
    var colours: [Color] {
        [.green, .orange, .yellow]
    }
    
    var data: [Double] {
        // split into groups
        // income
        // subscriptions?
        // utilities (groceries, fuel, etc)
        var incomeTotal = 0.0
        budgetItems
            .filter { item in item.wrappedName == "Income" }
            .forEach { item in
                incomeTotal += item.amount
            }
        var subscriptionTotal = 0.0
        budgetItems
            .filter { item in item.isSubscription }
            .forEach { item in
                subscriptionTotal += item.amount
            }
        
        var utilitiesTotal = 0.0
        budgetItems
            .filter { item in !item.isSubscription && item.wrappedName != "Income" }
            .forEach { item in
                utilitiesTotal += item.amount
            }
        
        return [incomeTotal, subscriptionTotal, utilitiesTotal]
    }
    
    var labels: [String] {
        ["Income", "Subscriptions", "Utilities"]
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
