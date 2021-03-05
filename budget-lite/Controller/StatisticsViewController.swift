//
//  StatisticsViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-02.
//

import UIKit
import RealmSwift

class StatisticsViewController: UIViewController {
    @IBOutlet weak var expensesAmountLabel: UILabel!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var changePeriodButton: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    
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
        
        setupView()
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
        
        if let year = selectedYear, let _ = selectedMonth {
            periodTextField.text = String(year) + " - " + months[row]
        }
    }
    
}
