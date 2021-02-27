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
    
    let realm = try! Realm()
    let alertService = AlertService()
    
    var spendingDates: Results<SpendingDate>?
    var expenses: Results<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRealmData()
        
        setupTableView()
    }

    
    // Add new expense

    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = alertService.alert(title: "Add Expense", buttonTitle: "Add") { (title, amount, date) in
            do {
                try self.realm.write {
                    let expense = Expense()
                    
                    expense.name = title
                    
                    let newAmountString = amount.replacingOccurrences(of: ",", with: ".")
                    let amountDouble = Double(newAmountString)!
                    expense.amount = amountDouble
                    
                    let spendingDate = SpendingDate()
                    spendingDate.date = date
                    
                    
                    self.realm.add(spendingDate)
                    spendingDate.expenses.append(expense)
                    
                    self.tableView.reloadData()
                }
            } catch {
                print("Error writing new object to realm, \(error)")
            }
        }
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
        let dateFormatter = DateFormatter()
        cell.dateLabel.text = dateFormatter.string(from: spendingDates?[section].date ?? Date(timeIntervalSinceNow: .zero))
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses?.count ?? 1
    }
    
    // Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = expenses?[indexPath.row].name ?? "Add new expense"
        cell.totalLabel.text = String(expenses?[indexPath.row].amount ?? 0.0)
        return cell
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
    }
    
}

