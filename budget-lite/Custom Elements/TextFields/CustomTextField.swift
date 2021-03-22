//
//  CustomTextField.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-23.
//

import UIKit

class CustomTextField: UITextField {

    override var placeholder: String? {
        didSet {
            setupPlaceholder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func changeLineColor(condition: Bool) {
        if let bottomLine = layer.sublayers?[0] {
            if condition {
                bottomLine.backgroundColor = UIColor(named: "black-color-jet")?.cgColor
            } else {
                bottomLine.backgroundColor = UIColor(named: "accent-color")?.cgColor
                setupPlaceholder(false)
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = .white
        textColor = UIColor(named: "black-color-jet")
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 6, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(named: "black-color-jet")?.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    private func setupPlaceholder(_ condition: Bool = true) {
        let color: UIColor
        if condition {
            color = UIColor(named: "placeholder-color")!
        } else {
            color = UIColor(named: "accent-placeholder-color")!
        }
        
        let placeholderString = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.attributedPlaceholder = placeholderString
    }
}
