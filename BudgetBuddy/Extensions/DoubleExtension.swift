//
//  DoubleExtension.swift
//  BudgetBuddy
//
//  Created by Tino on 26/9/21.
//

import Foundation

extension Double {
    var currencyString: String {
        self.formatted(.currency(code: Locale.current.currencyCode ?? "AUD"))
    }
}
