//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Дарья on 07.08.2025.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
