//
//  AlertViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AddExpenseAlertViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var amountTextField: CustomTextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var alertTitle = String()
    var actionButtonTitle = String()
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        nameTextField.returnKeyType = .done
        amountTextField.returnKeyType = .done
    }
    
    private func setupView() {
        nameTextField.becomeFirstResponder()
        
        nameTextField.placeholder = "e.g. 'Shopping'"
        amountTextField.placeholder = "e.g. '15,50'"
        
        amountTextField.keyboardType = .decimalPad
        
        titleLabel.text = alertTitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
        
        datePicker.tintColor = UIColor(named: "main-color")
        
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        dismiss(animated: true)
        buttonAction?()
    }
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddExpenseAlertViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldReturn = false
        if nameTextField.isFirstResponder {
            amountTextField.becomeFirstResponder()
        } else {
            shouldReturn = amountTextField.resignFirstResponder()
        }
        return shouldReturn
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == amountTextField {
            let mark = ","
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            if (oldText.contains(mark) || oldText.isEmpty) && string == mark  {
                return false
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            
            let numberOfDecimalDigits: Int
            if let decimalMarkIndex = newText.firstIndex(of: Character(mark)) {
                numberOfDecimalDigits = newText.distance(from: decimalMarkIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return numberOfDecimalDigits <= 2
        }
        
        return true
    }
}
