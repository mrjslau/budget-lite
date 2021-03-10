//
//  AlertService.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class AlertService {
    
    func alert(title: String, buttonTitle: String, type: Int, completion: @escaping (String, String, Date) -> Void) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        var vc: UIViewController
        
        if type == 0 {
            let alertVC = storyboard.instantiateViewController(identifier: "AddExpenseAlertVC") as! AddExpenseAlertViewController
            
            alertVC.alertTitle = title
            alertVC.actionButtonTitle = buttonTitle
            alertVC.buttonAction = completion
            
            vc = alertVC
        } else {
            let alertVC = storyboard.instantiateViewController(identifier: "AddRecurringExpenseAlertVC") as! AddRecurringExpenseAlertViewController
            
            alertVC.alertTitle = title
            alertVC.actionButtonTitle = buttonTitle
            alertVC.buttonAction = completion
            
            vc = alertVC
        }
        
        
        return vc
    }
    
    
    
}
