import UIKit
import CoreData

class TripExpenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ExpenseName: UITextField!
    @IBOutlet weak var TripName: UILabel!
    @IBOutlet weak var ExpenseAmount: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var ResetBtn: UIButton!
    @IBOutlet weak var TotalExpense: UILabel!
    @IBOutlet weak var tripExpenseTable: UITableView!
    
    var trip: UserTrip?
    var expenses: [UserTripExpense] = []
    private let coreDataHelper = CoreDataHelper()
    private var selectedExpense: UserTripExpense?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripName.text = trip?.tripName
        tripExpenseTable.dataSource = self
        tripExpenseTable.delegate = self

        loadExpenses()
        updateTotalExpense()
    }
    
    private func loadExpenses() {
        guard let tripName = trip?.tripName else { return }
        expenses = coreDataHelper.fetchExpenses(forTrip: tripName)
        tripExpenseTable.reloadData()
    }

    @IBAction func OnReset(_ sender: Any) {
        resetFields()
    }
    
    @IBAction func OnSave(_ sender: Any) {
        guard let expenseName = ExpenseName.text, !expenseName.isEmpty else {
            showAlert(title: "Input Error", message: "Expense name cannot be empty.")
            return
        }
        
        guard let expenseAmountText = ExpenseAmount.text, !expenseAmountText.isEmpty else {
            showAlert(title: "Input Error", message: "Amount cannot be empty.")
            return
        }
        
        guard let expenseAmount = Double(expenseAmountText) else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }
        
        guard let tripName = trip?.tripName else {
            showAlert(title: "Error", message: "Trip name is missing.")
            return
        }
        
        if let selectedExpense = selectedExpense {
            coreDataHelper.updateExpense(expense: selectedExpense, newExpenseName: expenseName, newAmount: String(expenseAmount))
        } else {
            coreDataHelper.createExpense(forTrip: tripName, expenseName: expenseName, amount: String(expenseAmount))
        }
        
        loadExpenses()
        updateTotalExpense()
        resetFields()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func resetFields() {
        ExpenseName.text = ""
        ExpenseAmount.text = ""
        selectedExpense = nil
    }
    
    private func updateTotalExpense() {
        let total = expenses.reduce(0.0) { (result, expense) -> Double in
            if let amountString = expense.expenseAmount, let amount = Double(amountString) {
                return result + amount
            } else {
                return result
            }
        }
        TotalExpense.text = "Total: $\(total)"
    }

    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenceTableViewCell", for: indexPath) as? ExpenceTableViewCell else {
            return UITableViewCell()
        }
        
        let expense = expenses[indexPath.row]
        cell.expenceName.text = expense.expenseName
        if let amount = expense.expenseAmount {
            cell.totalExpence.text = "$\(amount)"
        } else {
            cell.totalExpence.text = "$0.00"
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Populate the text fields with the selected expense details
        selectedExpense = expenses[indexPath.row]
        ExpenseName.text = selectedExpense?.expenseName
        ExpenseAmount.text = selectedExpense?.expenseAmount
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the expense from Core Data
            let expenseToDelete = expenses[indexPath.row]
            coreDataHelper.deleteExpense(expense: expenseToDelete)
            
            // Remove the expense from the local array
            expenses.remove(at: indexPath.row)
            
            // Update the total expense
            updateTotalExpense()
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
