//
//  ViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-22.
//

import UIKit

class OneTimeExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        registerCustomCells()
        tableView.rowHeight = 50
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //print(alert.textFields![0].text)
        }
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension OneTimeExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // TableView Sections
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
        return 4
    }
    
    // TableView Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = "Maxima"
        cell.totalLabel.text = "-45,67€"
        return cell
    }
    
    // TableView Register Custom Views
    private func registerCustomCells() {
        let cell = UINib(nibName: "ExpenseCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ExpenseCell")
        let header = UINib(nibName: "ExpenseSectionHeader", bundle: nil)
        tableView.register(header, forCellReuseIdentifier: "SectionHeader")
    }
    
}

