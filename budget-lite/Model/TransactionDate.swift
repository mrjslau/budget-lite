//
//  SpendingDate.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-25.
//

import RealmSwift

class TransactionDate: Object {
    @objc dynamic var year: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    let expenses = List<Expense>()
    let incomes = List<Income>()
}

extension TransactionDate {
    static func sortedByDate(ascending: Bool) -> Results<TransactionDate> {
        let realm = try! Realm()
        let spendingDatesSortProperties = [SortDescriptor(keyPath: "year", ascending: ascending),
                                           SortDescriptor(keyPath: "month", ascending: ascending),
                                           SortDescriptor(keyPath: "day", ascending: ascending)]
        return realm.objects(TransactionDate.self).sorted(by: spendingDatesSortProperties)
    }
}
