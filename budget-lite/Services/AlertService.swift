//
//  AlertService.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AlertService {
    
    func newTransactionAlert(title: String, buttonTitle: String, completion: @escaping (String, String, Date) -> Void) -> AddTransactionAlertVC {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AddTransactionAlertVC") as! AddTransactionAlertVC
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
    func newRecurringTransactionAlert(title: String, buttonTitle: String, completion: @escaping (String, String, String, Date) -> Void) -> AddRecurringTransactionAlertVC {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AddRecurringTransactionAlertVC") as! AddRecurringTransactionAlertVC
        
        alertVC.alertTitle = title
        alertVC.actionButtonTitle = buttonTitle
        alertVC.addRecurringTransactionAction = completion
        
        return alertVC
    }
    
}
