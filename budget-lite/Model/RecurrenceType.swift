//
//  Recurring.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-09.
//

import RealmSwift

class RecurrenceType: Object {
    // Interval if expense/income is recurring every X days
    var interval = RealmOptional<Int>()
    // Day if expense/income is recurring at the same calendar day
    var day = RealmOptional<Int>()
    
    let expenses = List<Expense>()
}
