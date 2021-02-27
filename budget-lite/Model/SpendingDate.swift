//
//  SpendingDate.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-25.
//

import RealmSwift

class SpendingDate: Object {
    @objc dynamic var year: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    let expenses = List<Expense>()
}
