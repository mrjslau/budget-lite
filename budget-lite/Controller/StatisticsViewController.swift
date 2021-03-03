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
    @IBOutlet weak var periodTextField: UITextField!
    
    var periodPicker = UIPickerView()
    
    let currentYear = Date().get(.year)
    let currentMonth = Date().get(.month)
    let currentDay = Date().get(.day)
    
    var existingDates: [Int : [Int]] = [:]
    var years: [Int] = []
    var months: [Int] = []
    
    var selectedYear: Int?
    var selectedMonth: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        periodTextField.inputView = periodPicker
        
        periodPicker.dataSource = self
        periodPicker.delegate = self
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

extension StatisticsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for date in RealmService.shared.spendingDates! {
            
            if !years.contains(date.year) {
                years.append(date.year)
            }
            
            if !months.contains(date.month) {
                months.append(date.month)
            }
        }
        
        
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(years[row])
        } else {
            return String(months[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = years[row]
            pickerView.reloadComponent(1)
        } else {
            selectedMonth = months[row]
        }
        
        if let year = selectedYear, let month = selectedMonth {
            periodTextField.text = String(year) + "-" + String(month)
            periodTextField.resignFirstResponder()
        }
    }
    
}
