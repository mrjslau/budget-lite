//
//  ViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-22.
//

import UIKit

class OneTimeExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let alertService = AlertService()
    
    let expenses = [
        ["sum" : 13.56, "name" : "Maxima"],
        ["sum" : 15.00, "name" : "Rimi"],
        ["sum" : 3.10, "name" : "Taxi"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        registerCustomCells()
        tableView.rowHeight = 50
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = alertService.alert(title: "Add Expense", buttonTitle: "Add") {
            print("Add tapped")
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension OneTimeExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! ExpenseSectionHeader
        cell.dateLabel.text = "23FEB"
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    // Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = expenses[indexPath.row]["name"] as? String
        cell.totalLabel.text = String((expenses[indexPath.row]["sum"] as? Double)!)
        return cell
    }
    
    // Register Custom Views
    private func registerCustomCells() {
        let cell = UINib(nibName: "ExpenseCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ExpenseCell")
        let header = UINib(nibName: "ExpenseSectionHeader", bundle: nil)
        tableView.register(header, forCellReuseIdentifier: "SectionHeader")
    }
    
}

