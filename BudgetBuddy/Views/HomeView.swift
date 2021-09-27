//
//  HomeView.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \BudgetItem.dateAdded, ascending: false)])
    var budgetItems: FetchedResults<BudgetItem>
    
    @EnvironmentObject var userModel: UserModel
    
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                userInfo
                Spacer()
                historyView
                    .padding(.horizontal)
                Spacer()
                recentItems
                    .padding(.horizontal)
            }
            
//            floatingAddButton
        }
    }
    /// The opacity for the "cards".
    private var opacity = 0.5
    
    /// The radius for the "cards".
    private var radius = 20.0
}

private extension HomeView {
    var historyView: some View {
        MonthlyTotalBarChart()
            .card()
            .overlay(alignment: .topLeading) {
                Text("History")
                    .font(.title2)
                    .padding(.horizontal)
            }
            .foregroundColor(.white)
    }
    
    var recentItems: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recent")
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(.white)
            
            ScrollView(showsIndicators: false) {
                ForEach(budgetItems) { item in
                    ItemRowView(item: item)
                        .padding(.horizontal)
                }
                .onDelete(perform: delete)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .leading)
        .background(Color("lightBlue").opacity(opacity))
        .clipShape(CustomRoundedRectangle(corners: [.topLeft, .topRight], radius: radius))
        
    }
    
    var userInfo: some View {
        VStack(alignment: .leading) {
            Text("Balance")
                .font(.system(size: 33, weight: .bold))
                .bold()
            Text(userModel.balance.currencyString)
                .fontWeight(.light)
                .font(.system(size: 30))
            HStack {
                VStack(alignment: .leading) {
                    Text("Income")
                    Text(userModel.income.currencyString)
                        .fontWeight(.light)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Spent")
                    Text(userModel.spending.currencyString)
                        .fontWeight(.light)
                }
            }
            .font(.system(size: 30))
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .none
//        formatter.dateStyle = .short
//        formatter.dateFormat = "dd/MM/y"
//        return formatter.string(from: date)
//    }

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
