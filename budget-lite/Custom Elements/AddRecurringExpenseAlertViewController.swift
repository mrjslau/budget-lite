//
//  AddRecurringExpenseAlertViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-09.
//

import UIKit

class AddRecurringExpenseAlertViewController: AddExpenseAlertViewController {
    @IBOutlet weak var periodTextField: CustomTextField!
    @IBOutlet weak var dateStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setupView() {
        super.setupView()
        dateStackView.isHidden = true
        
        periodTextField.placeholder = "e.g. '30'"
        periodTextField.returnKeyType = .done
        periodTextField.keyboardType = .decimalPad
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        
        if !nameTextField.text!.isEmpty && !amountTextField.text!.isEmpty && !periodTextField.text!.isEmpty {
            
            dismiss(animated: true)
            // FIX func 
            buttonAction?(nameTextField.text!, amountTextField.text!, datePicker.date)
            
        } else {
            nameTextField.text == "" ? nameTextField.changeLineColor(condition: false) : nameTextField.changeLineColor(condition: true)
            
            amountTextField.text == "" ? amountTextField.changeLineColor(condition: false) : amountTextField.changeLineColor(condition: true)
            
            periodTextField.text == "" ? periodTextField.changeLineColor(condition: false) : periodTextField.changeLineColor(condition: true)
        }
    }
    
}
