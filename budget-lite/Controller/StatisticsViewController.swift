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

    var years: [Int] = []
    var months: [String] = Calendar.current.shortMonthSymbols
    
    var selectedYear: Int? = Date().get(.year)
    var selectedMonth: Int? = Date().get(.month)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        periodTextField.inputView = periodPicker
        
        
        periodPicker.dataSource = self
        periodPicker.delegate = self
        
        
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        periodTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        updateTotalLabel()
        periodTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTotalLabel()
    }
    
    func updateTotalLabel() {
        let dates = RealmService.shared.spendingDates?.filter("year == %@ AND month == %@", selectedYear, selectedMonth)
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
            return months[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = years[row]
            pickerView.reloadComponent(1)
        } else {
            selectedMonth = row + 1
        }
        
        //if let year = selectedYear, let _ = selectedMonth {
        //    periodTextField.text = String(year) + "-" + months[row]
        //    periodTextField.resignFirstResponder()
        //
        //
        //    updateTotalLabel()
        //}
    }
    
}
