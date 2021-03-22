//
//  Income.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-19.
//

import RealmSwift

class Income: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var amount: Double = 0.0
    var transactionDate = LinkingObjects(fromType: TransactionDate.self, property: "incomes")
}
