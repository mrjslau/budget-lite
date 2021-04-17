//
//  ExchangeViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-24.
//

import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var exchangeData = ExchangeData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        exchangeData.delegate = self
    }
    
    
    @IBAction func addCurrencyPressed(_ sender: UIBarButtonItem) {
    }
}

extension ExchangeViewController: ExchangeDataDelegate {
    func didUpdateCurrency() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ExchangeViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerCustomCells()
        tableView.rowHeight = 100
        tableView.allowsSelection = false
    }
    
    private func registerCustomCells() {
        let nib = UINib(nibName: Constants.Cells.NibNames.exchange, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.ReuseIDs.exchange)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeData.getCurrenciesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.ReuseIDs.exchange) as! CurrencyCell
        
        let currencyCode = exchangeData.getCurrencyCode(at: indexPath.row)
        cell.codeLabel.text = currencyCode
        cell.flagLabel.text = Constants.Currencies.getFlag(code: currencyCode)
        cell.nameLabel.text = Constants.Currencies.getName(code: currencyCode)
        
        return cell
    }
    
    
}
