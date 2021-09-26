//
//  BudgetItem+CoreDataProperties.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//
//

import Foundation
import CoreData


extension BudgetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetItem> {
        return NSFetchRequest<BudgetItem>(entityName: "BudgetItem")
    }

    @NSManaged public var amount: Double
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isSubscription: Bool
    @NSManaged public var name: String?
    @NSManaged public var nextPayDate: Date?
    @NSManaged public var type: String?

    // wrappers
    public var wrappedDateAdded: Date {
        get { dateAdded ?? Date() }
        set { dateAdded = newValue }
    }
    
    public var wrappedID: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    public var wrappedName: String {
        get { name ?? "No name" }
        set { name = newValue }
    }
    
    public var wrappedNextPayDate: Date {
        get { nextPayDate ?? Date() }
        set { nextPayDate = newValue }
    }
    
    var wrappedType: ItemType {
        get { .init(rawValue: type ?? "no type") ?? ItemType.expense }
        set { type = newValue.rawValue }
    }
}

extension BudgetItem : Identifiable {

}
