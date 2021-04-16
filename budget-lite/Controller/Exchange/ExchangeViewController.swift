//
//  ExchangeViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-24.
//

import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager = ExchangeDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        dataManager.delegate = self
        dataManager.loadData()
        
        
        /*
        Network.shared.apollo.fetch(query: LatestEuroQuery()) { result in
            
            print(result)
            
            switch result {
            case .success(let graphQLResult):
                
                print(graphQLResult)
                
                print("GraphQL Success!")
                
                if let latest = graphQLResult.data?.latest {
                    print(latest)
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
        */
    }
    
    
    @IBAction func addCurrencyPressed(_ sender: UIBarButtonItem) {
    }
}

extension ExchangeViewController: ExchangeDataManagerDelegate {
    func didUpdateCurrency(_ manager: ExchangeDataManager, conversions: [String:Double]) {
        print(conversions)
    }
}

extension ExchangeViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerCustomCells()
        tableView.rowHeight = 50
        tableView.allowsSelection = false
    }
    
    private func registerCustomCells() {
        let nib = UINib(nibName: Constants.Cells.NibNames.exchange, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.ReuseIDs.exchange)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.ReuseIDs.exchange) as! CurrencyCell
    
        return cell
    }
    
    
}
