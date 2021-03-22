//
//  AddRecurringExpenseAlertViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-09.
//

import UIKit

class AddRecurringTransactionAlertVC: AddTransactionAlertVC {
    @IBOutlet weak var periodTextField: CustomTextField!
    
    var addRecurringTransactionAction: ((String, String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        periodTextField.placeholder = "e.g. '30'"
        periodTextField.returnKeyType = .done
        periodTextField.keyboardType = .decimalPad
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        
        if !nameTextField.text!.isEmpty && !amountTextField.text!.isEmpty && !periodTextField.text!.isEmpty {
            
            dismiss(animated: true)
            addRecurringTransactionAction?(nameTextField.text!, amountTextField.text!, periodTextField.text!, datePicker.date)
            
        } else {
            nameTextField.text == "" ? nameTextField.changeLineColor(condition: false) : nameTextField.changeLineColor(condition: true)
            
            amountTextField.text == "" ? amountTextField.changeLineColor(condition: false) : amountTextField.changeLineColor(condition: true)
            
            periodTextField.text == "" ? periodTextField.changeLineColor(condition: false) : periodTextField.changeLineColor(condition: true)
        }
    }
    
}
