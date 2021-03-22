//
//  Constants.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-19.
//

import Foundation
import UIKit

struct Constants {
    struct Fonts {
        static let segmentedControl = UIFont(name: "Open Sans", size: 14)
    }
    
    struct Titles {
        static let addTransaction = "Add Transaction"
        static let addExpense = "Add Expense"
        static let addIncome = "Add Income"
        static let addRecurringTransaction = "Add Recurring Transaction"
        static let buttonAdd = "Add"
    }
    
    struct Cells {
        
        struct NibNames {
            static let transaction = "TransactionCell"
            static let transactionHeader = "TransactionSectionHeader"
        }
        
        struct ReuseIDs {
            static let transaction = "TransactionCell"
            static let transactionHeader = "TransactionSectionHeader"
        }
        
    }
}
