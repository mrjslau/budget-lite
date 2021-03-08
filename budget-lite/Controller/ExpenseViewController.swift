//
//  ViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-22.
//

import UIKit

class ExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let realmService = RealmService.shared
    private let alertService = AlertService()
    
    private var segmentSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        segmentSelected = sender.selectedSegmentIndex
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = alertService.alert(title: "Add Expense", buttonTitle: "Add", completion: realmService.getNewExpenseFunction(tableView))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func setupView() {
        
        // Setup Segmented Control
        if let font = UIFont(name: "Open Sans", size: 14) {
            let fontAttribute: [NSAttributedString.Key: Any] = [.font : font, .foregroundColor: UIColor.white]
            segmentedControl.setTitleTextAttributes(fontAttribute, for: .normal)
        }
        
        // Setup Table View
        setupTableView()
    }
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = realmService.getSpendingDatesCount()
        return count > 0 ? count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! ExpenseSectionHeader
        
        if let date = realmService.getSpendingDate(index: section) {
            let monthString = Calendar.current.shortMonthSymbols[date.month - 1].uppercased()
            let dayString = String(date.day)
            
            cell.dateLabel.text = monthString + " " + dayString
        } else {
            cell.dateLabel.text = Calendar.current.shortMonthSymbols[Date().get(.month)] + " " + String(Date().get(.day))
        }
        
        return cell.contentView
    }
    
    // Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmService.getOneTimeExpensesCount(forSpendingDateAt: section) ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        
        if let date = realmService.getSpendingDate(index: indexPath.section) {
            let expense = date.expenses[indexPath.row]
            
            cell.nameLabel.text = expense.name
            cell.totalLabel.text = "-" + String(format: "%.2f", expense.amount) + "€"
        } else {
            cell.nameLabel.text = "Add expenses"
            cell.totalLabel.text = "-0.00€"
        }
        
        return cell
    }
    
    // Delete Expenses and Spending Dates with Swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmService.deleteOneTimeExpense(dateIndex: indexPath.section, expenseIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if realmService.getOneTimeExpensesCount(forSpendingDateAt: indexPath.section) == 0 {
                realmService.deleteSpendingDate(index: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .none)
            }
        }
    }
    
    // Custom Swipe To Delete Button
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "") { (action, view, boolValue) in
            self.tableView.dataSource?.tableView?(self.tableView, commit: .delete, forRowAt: indexPath)
        }
        deleteButton.image = UIImage(systemName: "xmark.circle.fill")

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteButton])
        return swipeActions
    }
    
    // Register Custom Views
    private func registerCustomCells() {
        let cell = UINib(nibName: "ExpenseCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ExpenseCell")
        let header = UINib(nibName: "ExpenseSectionHeader", bundle: nil)
        tableView.register(header, forCellReuseIdentifier: "SectionHeader")
    }
    
    // Setup Table View
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerCustomCells()
        tableView.rowHeight = 50
        tableView.allowsSelection = false
    }
    
}
