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
    
    init() {
        let spendingDatesSortProperties = [SortDescriptor(keyPath: "year", ascending: false), SortDescriptor(keyPath: "month", ascending: false), SortDescriptor(keyPath: "day", ascending: false)]
        spendingDates = realm.objects(SpendingDate.self).sorted(by: spendingDatesSortProperties)
    }
    
    func getSpendingDatesCount() -> Int {
        return spendingDates.count
    }
    
    func getOneTimeExpensesCount(forSpendingDateAt index: Int) -> Int? {
        return spendingDates.indices.contains(index) ? spendingDates[index].expenses.count : nil
    }
    
    func getSpendingDate(index: Int) -> SpendingDate? {
        return spendingDates.indices.contains(index) ? spendingDates[index] : nil
    }
    
    func getOneTimeExpense(dateIndex: Int, expenseIndex: Int) -> Expense? {
        if spendingDates.indices.contains(dateIndex) {
            return spendingDates[dateIndex].expenses.indices.contains(expenseIndex) ? spendingDates[dateIndex].expenses[expenseIndex] : nil
        } else {
            return nil
        }
    }
    
    func deleteSpendingDate(index: Int) {
        if spendingDates.indices.contains(index) {
            deleteObject(object: spendingDates[index])
        }
    }
    
    func deleteOneTimeExpense(dateIndex: Int, expenseIndex: Int) {
        if spendingDates.indices.contains(dateIndex) {
            if spendingDates[dateIndex].expenses.indices.contains(expenseIndex) {
                deleteObject(object: spendingDates[dateIndex].expenses[expenseIndex])
            }
        }
    }
    
    private func deleteObject(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error writing to realm, \(error)")
        }
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
