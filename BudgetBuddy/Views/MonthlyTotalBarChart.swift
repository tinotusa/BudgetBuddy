//
//  MonthlyTotalBarChart.swift
//  BudgetBuddy
//
//  Created by Tino on 27/9/21.
//

import SwiftUI

struct MonthlyTotalBarChart: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \BudgetItem.name, ascending: true)])
    var budgetItems: FetchedResults<BudgetItem>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<12) { month in
                    VStack {
                        Spacer()
                        Text("\(sumBudget(month).currencyString))")
                            .font(.footnote)
                            .rotationEffect(.degrees(-90))
                            .offset(y: -20)
                    Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 20, height: 200 * sumBudget(month) / maxAmount)
                    Text(monthName(month)) // invalid frame dimension ??
                        .font(.footnote)
                        .frame(width: 30)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var maxAmount: Double {
        var max = 0.0
        
        for month in 0..<12 {
            let monthSum = sumBudget(month)
            if  monthSum > max {
                max = monthSum
            }
        }
        return max + 1
    }
    
    func sumBudget(_ month: Int) -> Double {
        // get all months
        let months = budgetItems.filter { item in
            Calendar
                .current
                .dateComponents([.month], from: item.wrappedDateAdded).month! == month + 1 // + 1 because of 0 based index
        }
        // and sum
        return months.reduce(0.0) { result, item in result + item.amount }
    }
    
    func monthName(_ index: Int) -> String {
        Calendar.current.shortMonthSymbols[index]
    }
}

struct MonthlyTotalBarChart_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyTotalBarChart()
    }
}
