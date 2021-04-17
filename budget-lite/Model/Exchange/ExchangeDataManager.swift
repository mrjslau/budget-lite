//
//  ExchangeDataManager.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-04-16.
//

import Foundation

class ExchangeDataManager {
    
    private let baseURLString = "https://free.currconv.com/api/v7/convert?q="
    private let parametersURLString = "&compact=ultra&apiKey="
    
    private var currenciesString = ""
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "API_keys", ofType: "plist") else {
                fatalError("Could not find file 'API_keys.plist'")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "currency_converter") as? String else {
                fatalError("Could not find 'currency_converter' API key in 'API_keys.plist'")
            }
            
            return value
        }
    }
    
    private var exchangeURL: URL {
        get {
            let urlString = baseURLString + currenciesString + parametersURLString + apiKey
            currenciesString = ""
            return URL(string: urlString)!
        }
    }
    
    var delegate: ExchangeDataManagerDelegate?
    
    private func setCurrenciesString(base: String, currencies: [String]) {
        currenciesString = ""
        
        for item in currencies {
            if currenciesString.isEmpty {
                currenciesString += base + "_" + item
            } else {
                currenciesString += "," + base + "_" + item
            }
        }
    }
    
    /// Public method for data loading
    func loadData(base: String, currencies: [String]) {
        
        setCurrenciesString(base: base, currencies: currencies)
        
        print(currenciesString)
        
        performRequest(with: exchangeURL) { (data, response, error) in
            if let safeData = data {
                if let conversions = self.parseJSON(safeData) {
                    self.delegate?.didUpdateCurrency(self, conversions: conversions)
                }
            }
        }
    }
    
    /// Perform request - create session and data task
    private func performRequest(with url: URL, completion: @escaping ((Data?, URLResponse?, Error?) -> Void) ) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url, completionHandler: completion)
        
        task.resume()
    }
    
    /// Parse JSON response from API data
    private func parseJSON(_ data: Data) -> [String:Double]? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([String:Double].self, from: data)
            return decodedData
            
        } catch {
            print("Error decoding data \(error)")
            return nil
        }
    }
}

protocol ExchangeDataManagerDelegate {
    func didUpdateCurrency(_ manager: ExchangeDataManager, conversions: [String:Double])
}
