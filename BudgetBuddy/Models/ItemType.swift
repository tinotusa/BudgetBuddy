//
//  ItemType.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import Foundation

/*
 open
 internal
 public
 private
 file-private
 */

enum ItemType: String, CaseIterable, Identifiable {
    case expense, income
    
    var id: Self {
        self
    }
    
}
