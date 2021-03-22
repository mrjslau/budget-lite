//
//  Expense.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-25.
//

import RealmSwift

class Expense: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var amount: Double = 0.0
    var transactionDate = LinkingObjects(fromType: TransactionDate.self, property: "expenses")
}
