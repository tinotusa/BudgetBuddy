//
//  User.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import Foundation

struct User {
    var name: String
    var balance: Double
    var income = 0.0
    var spent = 0.0
    
    init() {
        self.init(name: "")
        load()
    }
    
    init(name: String, balance: Double = 0.0) {
        self.name = name
        self.balance = balance
    }
    
    mutating func delete(_ item: BudgetItem) {
        switch item.wrappedType {
        case .expense: spent -= item.amount
        case .income: income -= item.amount
        }
    }
}

extension User: Codable {
    private static let userSaveKey = "User"
    
    mutating func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.userSaveKey) else { return }
        do {
            self = try JSONDecoder().decode(User.self, from: data)
        } catch let error as NSError {
            print("Failed to decode user from UserData: \(error.userInfo)")
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: Self.userSaveKey)
        } catch let error as NSError {
            print("Failed to encode user: \(error.userInfo)")
        }
    }
}
