import UIKit

class AddTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TripName: UITextField!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var todoTable: UITableView!

    var currentTrip: Trip = Trip(tripName: "", startLocation: "", endLocation: "", startDate: "", endDate: "", todoItems: [], expenses: [])
    var todoItems: [String] = []
    let coreDataHelper = CoreDataHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        startDate.minimumDate = today
        endDate.minimumDate = today
        
        startDate.date = today
        endDate.date = today
        
        todoTable.dataSource = self
        todoTable.delegate = self
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Please Enter below Fields", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if message == "Trip saved successfully!" {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if message == "Trip saved successfully!" {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func OnSave(_ sender: Any) {
        var errorMessage = ""

        if let tripName = TripName.text, tripName.isEmpty {
            errorMessage += "Please enter the trip name.\n"
        }

        if let startLocation = startLocation.text, startLocation.isEmpty {
            errorMessage += "Please enter the start location.\n"
        }

        if let endLocation = endLocation.text, endLocation.isEmpty {
            errorMessage += "Please enter the end location.\n"
        }

        if !errorMessage.isEmpty {
            showAlert(message: errorMessage.trimmingCharacters(in: .whitespacesAndNewlines))
            return
        }

        let formattedStartDate = formatDate(date: startDate.date)
        let formattedEndDate = formatDate(date: endDate.date)

        if let _ = coreDataHelper.createTrip(tripName: TripName.text!, startLocation: startLocation.text!, endLocation: endLocation.text!, startDate: formattedStartDate, endDate: formattedEndDate, todoItems: todoItems) {
            showAlertSuccess(message: "Trip saved successfully!")
        } else {
            showAlertSuccess(message: "Failed to save the trip.")
        }
    }

    @IBAction func OnAddTodo(_ sender: Any) {
        let alert = UIAlertController(title: "New Todo", message: "Enter a new todo item", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Todo item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let todoText = alert.textFields?.first?.text, !todoText.isEmpty {
                self.todoItems.append(todoText)
                self.todoTable.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func OnReset(_ sender: Any) {
        TripName.text = ""
        startLocation.text = ""
        endLocation.text = ""
        startDate.date = Date()
        endDate.date = Date()
        todoItems.removeAll()
        todoTable.reloadData()
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        cell.todoItem.text = todoItems[indexPath.row]
        return cell
    }
}
