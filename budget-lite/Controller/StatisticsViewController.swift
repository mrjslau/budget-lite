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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTotalLabel()
    }
    
    func updateTotalLabel() {
        var total: Double = 0.0
        for expense in RealmService.shared.expenses! {
            total += expense.amount
        }
    
        totalLabel.text = "-" + String(total) + "€"
    }

}
