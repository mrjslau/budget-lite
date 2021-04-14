//
//  ExchangeViewController.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-03-24.
//

import UIKit

class ExchangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    
}
