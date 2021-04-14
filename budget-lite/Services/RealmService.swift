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
    var transactionDates: Results<TransactionDate>
    var periodicPayments: Results<RecurringTransaction>
    
    init() {
        transactionDates = TransactionDate.sortedByDate(ascending: false)
        periodicPayments = realm.objects(RecurringTransaction.self)
    }
    
    func getTransactionDatesCount() -> Int {
        return transactionDates.count
    }
    
    func getOneTimeExpensesCount(forSpendingDateAt index: Int) -> Int? {
        return transactionDates.indices.contains(index) ? transactionDates[index].expenses.count : nil
    }
    
    func getPeriodicPaymentsCount() -> Int {
        return periodicPayments.count
    }
    
    func getIncomesCount(forTransactionDateAt index: Int) -> Int? {
        return transactionDates.indices.contains(index) ? transactionDates[index].incomes.count : nil
    }
    
    func getTransactionDate(index: Int) -> TransactionDate? {
        return transactionDates.indices.contains(index) ? transactionDates[index] : nil
    }
    
    func getOneTimeExpense(dateIndex: Int, expenseIndex: Int) -> Expense? {
        if transactionDates.indices.contains(dateIndex) {
            return transactionDates[dateIndex].expenses.indices.contains(expenseIndex) ? transactionDates[dateIndex].expenses[expenseIndex] : nil
        } else {
            return nil
        }
    }
    
    func getPeriodicPayment(index: Int) -> RecurringTransaction? {
        return periodicPayments.indices.contains(index) ? periodicPayments[index] : nil
    }
    
    func deleteTransactionDate(index: Int) {
        if transactionDates.indices.contains(index) {
            deleteObject(object: transactionDates[index])
        }
    }
    
    func deleteOneTimeExpense(dateIndex: Int, expenseIndex: Int) {
        if transactionDates.indices.contains(dateIndex) {
            if transactionDates[dateIndex].expenses.indices.contains(expenseIndex) {
                deleteObject(object: transactionDates[dateIndex].expenses[expenseIndex])
            }
        }
    }
    
    func deletePeriodicPayment(index: Int) {
        if periodicPayments.indices.contains(index) {
            deleteObject(object: periodicPayments[index])
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
                    
                    for record in self.transactionDates {
                        if record.day == date.get(.day) && record.month == date.get(.month) && record.year == date.get(.year) {
                            record.expenses.append(expense)
                            exists = true
                            break
                        }
                    }
                    
                    if !exists {
                        let spendingDate = TransactionDate()
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
    
    func getNewIncomeFunction(_ tableView: UITableView) -> ((String, String, Date) -> Void) {
        func newIncome (title: String, amount: String, date: Date) {
            do {
                try self.realm.write {
                    let income = Income()
                    
                    income.name = title
                    
                    let newAmountString = amount.replacingOccurrences(of: ",", with: ".")
                    let amountDouble = Double(newAmountString)!
                    income.amount = amountDouble
                    
                    var exists = false
                    
                    for record in self.transactionDates {
                        if record.day == date.get(.day) && record.month == date.get(.month) && record.year == date.get(.year) {
                            record.incomes.append(income)
                            exists = true
                            break
                        }
                    }
                    
                    if !exists {
                        let spendingDate = TransactionDate()
                        spendingDate.year = date.get(.year)
                        spendingDate.month = date.get(.month)
                        spendingDate.day = date.get(.day)
                        self.realm.add(spendingDate)
                        spendingDate.incomes.append(income)
                    }
                    
                    tableView.reloadData()
                }
            } catch {
                print("Error writing new object to realm, \(error)")
            }
        }
        
        return newIncome(title:amount:date:)
    }
    
    func getNewPeriodicPaymentFunction(_ tableView: UITableView) -> ((String, String, String, Date) -> Void) {
        func newPeriodicPayment (title: String, amount: String, period: String, date: Date) {
            do {
                try self.realm.write {
                    let periodicPayment = RecurringTransaction()
                    
                    // Set name
                    periodicPayment.name = title
                    
                    // Set amount
                    let newAmountString = amount.replacingOccurrences(of: ",", with: ".")
                    let amountDouble = Double(newAmountString)!
                    periodicPayment.amount = amountDouble
                    
                    // Set interval
                    periodicPayment.interval = Int(period)!
                    
                    // Set last billing date
                    periodicPayment.lastBillingYear = date.get(.year)
                    periodicPayment.lastBillingMonth = date.get(.month)
                    periodicPayment.lastBillingDay = date.get(.day)
                    
                    self.realm.add(periodicPayment)
                    
                    tableView.reloadData()
                }
            } catch {
                print("Error writing new object to realm, \(error)")
            }
        }
        
        return newPeriodicPayment(title:amount:period:date:)
    }
}
