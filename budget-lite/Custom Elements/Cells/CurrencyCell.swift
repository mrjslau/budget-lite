//
//  CurrencyCell.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-04-14.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var textFieldAction: ((Any) -> Void)?
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        self.textFieldAction?(sender)
    }
}
