import UIKit

class TripExpenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ExpenseName: UITextField!
    @IBOutlet weak var TripName: UILabel!
    @IBOutlet weak var ExpenseAmount: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var ResetBtn: UIButton!
    
    @IBOutlet weak var TotalExpense: UILabel!
    @IBOutlet weak var tripExpenseTable: UITableView!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripName.text = trip?.tripName
        tripExpenseTable.dataSource = self
        tripExpenseTable.delegate = self
        
        // Calculate and display the total expense when the view loads
        updateTotalExpense()
    }
    
    @IBAction func OnReset(_ sender: Any) {
        ExpenseName.text = ""
        ExpenseAmount.text = ""
    }
    
    @IBAction func OnSave(_ sender: Any) {
        guard let expenseName = ExpenseName.text, !expenseName.isEmpty else {
            showAlert(title: "Input Error", message: "Expense name cannot be empty.")
            return
        }
        
        // Check if the amount field is empty
        guard let expenseAmountText = ExpenseAmount.text, !expenseAmountText.isEmpty else {
            showAlert(title: "Input Error", message: "Amount cannot be empty.")
            return
        }
        
        // Check if the amount is a valid number
        guard let expenseAmount = Double(expenseAmountText) else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }
        
        // Proceed with saving the expense if validation is successful
        let newExpense = Expense(name: expenseName, amount: expenseAmount)
        trip?.expenses.insert(newExpense, at: 0)
        tripExpenseTable.reloadData()
        
        // Update the total expense after adding a new expense
        updateTotalExpense()

        // Clear the input fields after saving
        ExpenseName.text = ""
        ExpenseAmount.text = ""
        
        // Update the trip in the trips array
        if let index = trips.firstIndex(where: { $0.tripName == trip?.tripName && $0.startLocation == trip?.startLocation && $0.endLocation == trip?.endLocation }) {
            trips[index] = trip!
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateTotalExpense() {
        let total = trip?.expenses.reduce(0) { $0 + $1.amount } ?? 0
        TotalExpense.text = "Total: $\(total)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.expenses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenceTableViewCell", for: indexPath) as? ExpenceTableViewCell else {
            return UITableViewCell()
        }
        
        if let expense = trip?.expenses[indexPath.row] {
            cell.expenceName.text = expense.name
            cell.totalExpence.text = "$\(expense.amount)"
        }
        
        return cell
    }
}
