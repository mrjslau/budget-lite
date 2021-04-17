//
//  ExchangeData.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-04-17.
//

import Foundation

class ExchangeData {
    
    private var dataManager = ExchangeDataManager()
    private var baseCurrency: String
    private var allCurrencies: [String] = []
    private var allAmounts: [String : Double] = [:]
    private var exchangeRates: [String : Double] = [:]
    
    var delegate: ExchangeDataDelegate?
    
    init(base: String = "USD", currencies: [String] = ["EUR", "CHF"]) {
        baseCurrency = base
        allCurrencies.append(base)
        allCurrencies.append(contentsOf: currencies)
        
        for currency in allCurrencies {
            allAmounts[currency] = 1.00
        }
        
        dataManager.delegate = self
        dataManager.loadData(base: base, currencies: currencies)
    }
    
    func updateExchangeRates(base: String) {
        var index: Int?
        
        for i in 0..<allCurrencies.count {
            if base == allCurrencies[i] {
                allCurrencies.remove(at: i)
                index = i
                break
            }
        }
        
        dataManager.loadData(base: base, currencies: allCurrencies)
        
        if let i = index {
            allCurrencies.insert(base, at: i)
        }
    }
    
    func getCurrencyCode(at index: Int) -> String {
        return allCurrencies[index]
    }
    
    func getCurrenciesCount() -> Int {
        return allCurrencies.count
    }
    
    // ? fix
    func exchangeCurrency(currency code: String, amount: Double) {
        for currency in allCurrencies {
            if code != currency {
                print(currency)
                //allAmounts[currency] = amount * exchangeRates[code]!
            }
        }
    }
    
    func setBaseCurrency(currency code: String) {
        baseCurrency = code
    }

}

extension ExchangeData: ExchangeDataManagerDelegate {
    func didUpdateCurrency(_ manager: ExchangeDataManager, conversions: [String : Double]) {
        exchangeRates = conversions
        delegate?.didUpdateCurrency()
    }
}

protocol ExchangeDataDelegate {
    func didUpdateCurrency()
}
