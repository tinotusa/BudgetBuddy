//
//  BudgetItem+CoreDataProperties.swift
//  BudgetBuddy
//
//  Created by Tino on 25/9/21.
//
//

import Foundation
import CoreData


extension BudgetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetItem> {
        return NSFetchRequest<BudgetItem>(entityName: "BudgetItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isSubscription: Bool
    @NSManaged public var nextPayDate: Date?
    @NSManaged public var id: UUID?
    
}

extension BudgetItem : Identifiable {

}
