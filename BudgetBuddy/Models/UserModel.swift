//
//  UserModel.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import Foundation

final class UserModel: ObservableObject {
    @Published var user = User() {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func save() {
        user.save()
    }
    
    func load() {
        user.load()
    }
    
    func delete(_ item: BudgetItem) {
        user.delete(item)
    }

    func update(_ item: BudgetItem) {
        user.update(item)
    }
}

// MARK: - GETTERS SETTERS
extension UserModel {
    var name: String {
        get { user.name }
        set { user.name = newValue }
    }
    
    var balance: Double {
        get { user.balance }
        set { user.balance = newValue }
    }
    
    var income: Double {
        get { user.income }
        set { user.income = newValue }
    }
    
    var spending: Double {
        get { user.spent }
        set { user.spent = newValue }
    }
}

