//
//  ViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-22.
//

import UIKit
import RealmSwift

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

class OneTimeExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let alertService = AlertService()
    let realmService = RealmService.shared
    
    var spendingDates: Results<SpendingDate>?
    var expenses: Results<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRealmData()
        
        setupTableView()
    }

    
    // Add new expense FIX same day validation FIX move from controller
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = alertService.alert(title: "Add Expense", buttonTitle: "Add", completion: realmService.getNewExpenseFunction(tableView))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func loadRealmData() {
        spendingDates = realm.objects(SpendingDate.self)
        expenses = realm.objects(Expense.self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
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

