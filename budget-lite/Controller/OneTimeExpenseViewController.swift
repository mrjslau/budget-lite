//
//  ViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-22.
//

import UIKit
import RealmSwift

class OneTimeExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let realm = try! Realm()
    private let realmService = RealmService.shared
    private let alertService = AlertService()
    
    var spendingDates: Results<SpendingDate>?
    var expenses: Results<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRealmData()
        setupView()
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = alertService.alert(title: "Add Expense", buttonTitle: "Add", completion: realmService.getNewExpenseFunction(tableView))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func loadRealmData() {
        let spendingDatesSortProperties = [SortDescriptor(keyPath: "year", ascending: false), SortDescriptor(keyPath: "month", ascending: false), SortDescriptor(keyPath: "day", ascending: false)]
        spendingDates = realm.objects(SpendingDate.self).sorted(by: spendingDatesSortProperties)
        expenses = realm.objects(Expense.self)
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

extension OneTimeExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return spendingDates?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! ExpenseSectionHeader
        
        if let date = spendingDates?[section] {
            let monthString = Calendar.current.shortMonthSymbols[date.month - 1].uppercased()
            let dayString = String(date.day)
            
            cell.dateLabel.text = monthString + " " + dayString
        } else {
            cell.dateLabel.text = "---"
        }
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingDates?[section].expenses.count ?? 1
    }
    
    // Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        
        if let date = spendingDates?[indexPath.section] {
            let expense = date.expenses[indexPath.row]
            
            cell.nameLabel.text = expense.name
            cell.totalLabel.text = "-" + String(format: "%.2f", expense.amount) + "€"
        } else {
            cell.nameLabel.text = "Add new expense"
            cell.totalLabel.text = "--.--€"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmService.deleteObject(object: spendingDates![indexPath.section].expenses[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if spendingDates![indexPath.section].expenses.isEmpty {
                realmService.deleteObject(object: spendingDates![indexPath.section])
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

