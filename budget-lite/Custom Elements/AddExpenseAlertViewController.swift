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
    var buttonAction: ((String, String, Date) -> Void)?
    
    private var originalAlertTransform: CGAffineTransform?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        originalAlertTransform = mainView.transform
    }
    
    private func setupView() {
        // -- Setup Text Fields
        nameTextField.becomeFirstResponder()
        
        nameTextField.placeholder = "e.g. 'Shopping'"
        amountTextField.placeholder = "e.g. '15,50'"
        
        nameTextField.returnKeyType = .done
        amountTextField.returnKeyType = .done
        
        nameTextField.autocapitalizationType = .sentences
        
        amountTextField.keyboardType = .decimalPad
        
        // -- Setup Labels and Buttons
        titleLabel.text = alertTitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
        
        // -- Setup Date Picker
        datePicker.tintColor = UIColor(named: "main-color")
        
        // -- Setup Container View UI
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        // -- Dismiss Keyboard on Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // -- Add Keyboard Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        let translateTransform = originalAlertTransform!.translatedBy(x: 0.0, y: -80.0)
        UIView.animate(withDuration: 0.2) {
            self.mainView.transform = translateTransform
        }
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.2) {
            self.mainView.transform = self.originalAlertTransform!
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        
        if !nameTextField.text!.isEmpty && !amountTextField.text!.isEmpty {
            
            dismiss(animated: true)
            buttonAction?(nameTextField.text!, amountTextField.text!, datePicker.date)
            
        } else {
            nameTextField.text == "" ? nameTextField.changeLineColor(condition: false) : nameTextField.changeLineColor(condition: true)
            
            amountTextField.text == "" ? amountTextField.changeLineColor(condition: false) : amountTextField.changeLineColor(condition: true)
        }
        
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
