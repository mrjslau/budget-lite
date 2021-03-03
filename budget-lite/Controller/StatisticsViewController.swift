//
//  StatisticsViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-02.
//

import UIKit
import RealmSwift

class StatisticsViewController: UIViewController {
    @IBOutlet weak var expensesTypeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    let currentYear = Date().get(.year)
    let currentMonth = Date().get(.month)
    let currentDay = Date().get(.day)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTotalLabel()
    }
    
    func updateTotalLabel() {
        let dates = RealmService.shared.spendingDates?.filter("year == %@ AND month == %@", currentYear, currentMonth)
        var total = 0.0
        
        for date in dates! {
            for expense in date.expenses {
                total += expense.amount
            }
        }
    
        totalLabel.text = "-" + String(format: "%.2f", total) + "€"
    }

}
