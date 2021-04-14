//
//  Extensions.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-06.
//

import Foundation
import UIKit

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
