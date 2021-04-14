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
            static let exchange = "CurrencyCell"
        }
        
        struct ReuseIDs {
            static let transaction = "TransactionCell"
            static let transactionHeader = "TransactionSectionHeader"
            static let exchange = "CurrencyCell"
        }
        
    }
    
    struct Segues {
        
        static let showTransactions = "showTransactions"
        
    }
    
    struct API {
        static let swopURL = URL(string: "https://swop.cx/graphql?api-key=7cf7389be40f62d9c4e9855ee9c597a03f853bc8d3e30db568de4c61623b4eed")!
        static let apiKey = "7cf7389be40f62d9c4e9855ee9c597a03f853bc8d3e30db568de4c61623b4eed"
    }
}
