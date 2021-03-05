//
//  RealmService.swift
//  budget-lite
//
//  Created by Marijus Laucevicius on 2021-02-28.
//

import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private let realm = try! Realm()
    var spendingDates: Results<SpendingDate>
    var expenses: Results<Expense>
    
    init() {
        spendingDates = realm.objects(SpendingDate.self)
        expenses = realm.objects(Expense.self)
    }
    
    func getNewExpenseFunction(_ tableView: UITableView) -> ((String, String, Date) -> Void) {
        func newExpense (title: String, amount: String, date: Date) {
            do {
                try self.realm.write {
                    let expense = Expense()
                    
                    expense.name = title
                    
                    let newAmountString = amount.replacingOccurrences(of: ",", with: ".")
                    let amountDouble = Double(newAmountString)!
                    expense.amount = amountDouble
                    
                    var exists = false
                    
                    for record in self.spendingDates {
                        if record.day == date.get(.day) && record.month == date.get(.month) && record.year == date.get(.year) {
                            record.expenses.append(expense)
                            exists = true
                            break
                        }
                    }
                    
                    if !exists {
                        let spendingDate = SpendingDate()
                        spendingDate.year = date.get(.year)
                        spendingDate.month = date.get(.month)
                        spendingDate.day = date.get(.day)
                        self.realm.add(spendingDate)
                        spendingDate.expenses.append(expense)
                    }
                    
                    tableView.reloadData()
                }
            } catch {
                print("Error writing new object to realm, \(error)")
            }
        }
        
        return newExpense(title:amount:date:)
    }
}
