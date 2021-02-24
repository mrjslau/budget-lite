//
//  AlertService.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AlertService {
    
    func alert(title: String, buttonTitle: String, completion: @escaping () -> Void) -> AddExpenseAlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AddExpenseAlertVC") as! AddExpenseAlertViewController
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
}
