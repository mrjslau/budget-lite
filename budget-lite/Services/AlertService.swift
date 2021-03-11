//
//  AlertService.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AlertService {
    
    func alert(title: String, buttonTitle: String, completion: @escaping (String, String, Date) -> Void) -> AddExpenseAlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AddExpenseAlertVC") as! AddExpenseAlertViewController
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
    func periodicAlert(title: String, buttonTitle: String, completion: @escaping (String, String, String, Date) -> Void) -> AddRecurringExpenseAlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AddRecurringExpenseAlertVC") as! AddRecurringExpenseAlertViewController
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        alertVC.addPeriodicalPaymentAction = completion
        
        return alertVC
    }
    
}
