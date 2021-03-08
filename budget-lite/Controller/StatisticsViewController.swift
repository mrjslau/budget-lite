//
//  StatisticsViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-02.
//

import UIKit
import RealmSwift

class StatisticsViewController: UIViewController {
    @IBOutlet weak private var periodTextField: UITextField!
    @IBOutlet weak private var changePeriodButton: UIButton!
    @IBOutlet weak private var expensesAmountLabel: UILabel!
    @IBOutlet weak private var categoriesTableView: UITableView!
    
    private var periodPicker = UIPickerView()

    private var years: [Int] = []                                 // available years e.g. [2020, 2021]
    private var months: [Int] = []                                // available months e.g. [1, 5, 12]
    private let monthStrings = Calendar.current.monthSymbols      // zero-based 12 strings for month names
    
    
    private let currentYear = Date().get(.year)
    private let currentMonth = Date().get(.month)
    private var selectedYear: Int = Date().get(.year)             // e.g. 2020
    private var selectedMonth: Int = Date().get(.month)           // 1...12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadYears()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTotalLabel()
        loadYears()
    }
    
    
    
    private func loadYears() {
        for date in RealmService.shared.spendingDates {
            if !years.contains(date.year) {
                years.append(date.year)
            }
        }
        
        loadMonths()
    }
    
    private func loadMonths() {
        let dates = RealmService.shared.spendingDates.filter("year == %@", selectedYear)
        
        months = []
        for date in dates {
            if !months.contains(date.month) {
                months.append(date.month)
            }
        }
        
        selectedMonth = months.isEmpty ? Date().get(.month) : months[0]
    }
    
    private func setupView() {
        periodPicker.dataSource = self
        periodPicker.delegate = self
        
        // Create Toolbar for UIPickerView
        let periodPickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePicker))
        periodPickerToolbar.setItems([doneButton], animated: false)
        periodPickerToolbar.isUserInteractionEnabled = true
        
        periodPickerToolbar.barStyle = .default
        periodPickerToolbar.tintColor = .white
        periodPickerToolbar.isTranslucent = true
        
        // Assign UIPickerView and UIToolbar to UITextField
        periodTextField.inputView = periodPicker
        periodTextField.inputAccessoryView = periodPickerToolbar
        periodTextField.tintColor = .clear
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributedString = NSAttributedString(string: "This Month", attributes: underlineAttribute)
        periodTextField.attributedText = attributedString
        
        // Adjust UI
        changePeriodButton.layer.masksToBounds = true
        changePeriodButton.layer.cornerRadius = 10
    }
    
    @objc private func donePicker() {
        periodTextField.resignFirstResponder()
    }
    
    private func updateTotalLabel() {
        let dates = RealmService.shared.spendingDates.filter("year == %@ AND month == %@", selectedYear, selectedMonth)
        var total = 0.0
        
        for date in dates {
            for expense in date.expenses {
                total += expense.amount
            }
        }
    
        expensesAmountLabel.text = "-" + String(format: "%.2f", total) + "€"
    }
    
    @IBAction func changePeriodPressed(_ sender: UIButton) {
        periodTextField.becomeFirstResponder()
    }
}

extension StatisticsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
            let monthNumeric = months[row]
            return monthStrings[monthNumeric - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !years.isEmpty && !months.isEmpty {
            if component == 0 {
                selectedYear = years[row]
                loadMonths()
                pickerView.reloadComponent(1)
            } else {
                selectedMonth = months[row]
            }
            
            if selectedYear == currentYear && selectedMonth == currentMonth {
                periodTextField.text = "This Month"
            } else {
                periodTextField.text = String(selectedYear) + " - " + monthStrings[selectedMonth - 1]
            }
            
            updateTotalLabel()
        }
    }
}
