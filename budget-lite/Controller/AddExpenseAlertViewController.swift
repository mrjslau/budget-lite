//
//  AlertViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AddExpenseAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
    }
    @IBAction func didTapCancelButton(_ sender: UIButton) {
    }
}
