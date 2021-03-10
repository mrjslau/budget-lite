//
//  Recurring.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-09.
//

import RealmSwift

class PeriodicPayment: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var interval: Int = 0
    
    @objc dynamic var lastBillingYear: Int = 0
    @objc dynamic var lastBillingMonth: Int = 0
    @objc dynamic var lastBillingDay: Int = 0
}
