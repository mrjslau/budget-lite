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
    private var exchangeRates: [String : Double] = [:]
    
    var delegate: ExchangeDataDelegate?
    
    init(base: String = "USD", currencies: [String] = ["EUR", "CHF"]) {
        baseCurrency = base
        allCurrencies.append(base)
        allCurrencies.append(contentsOf: currencies)
        
        dataManager.delegate = self
        dataManager.loadData(base: base, currencies: currencies)
    }
    
    func getCurrencyCode(at index: Int) -> String {
        return allCurrencies[index]
    }
    
    func getCurrenciesCount() -> Int {
        return allCurrencies.count
    }
    
    func exchangeCurrency(currency code: String, amount: Double) -> Double {
        let exchangeRate = exchangeRates[code]
        return amount * exchangeRate!
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
