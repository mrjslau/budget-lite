//
//  SpendingDate.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-25.
//

import RealmSwift

class SpendingDate: Object {
    @objc dynamic var date: Date = Date()
    let expenses = List<Expense>()
}
