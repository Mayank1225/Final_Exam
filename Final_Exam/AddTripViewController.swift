//
//  AddTripViewController.swift
//  Final_Exam
//
//  Created by user252704 on 8/16/24.
//

import UIKit
var trips: [Trip] = [
    Trip(tripName: "Beach Getaway",
         startLocation: "New York, NY",
         endLocation: "Miami, FL",
         startDate: "01/09/2024",
         endDate: "08/09/2024",
         todoItems: ["Visit the beach", "Party at the club", "Go snorkeling"],
         expenses: [
            Expense(name: "Flight Tickets", amount: 350.0),
            Expense(name: "Hotel Stay", amount: 1200.0),
            Expense(name: "Beachside Dinner", amount: 150.0)
         ]),
    
    Trip(tripName: "Local Exploration",
             startLocation: "Kitchener, ON",
             endLocation: "Waterloo, ON",
             startDate: "01/11/2024",
             endDate: "01/11/2024",
             todoItems: ["Visit local parks", "Explore universities", "Dine at local restaurants"],
             expenses: [
                Expense(name: "Lunch", amount: 50.0),
                Expense(name: "Parking", amount: 10.0),
                Expense(name: "Souvenirs", amount: 25.0)
             ]),
    
    Trip(tripName: "Mountain Adventure",
         startLocation: "Denver, CO",
         endLocation: "Aspen, CO",
         startDate: "10/09/2024",
         endDate: "15/09/2024",
         todoItems: ["Hiking", "Campfire", "Mountain biking"],
         expenses: [
            Expense(name: "Camping Gear", amount: 200.0),
            Expense(name: "Mountain Guide", amount: 150.0),
            Expense(name: "Food Supplies", amount: 100.0)
         ]),
    
    Trip(tripName: "City Tour",
         startLocation: "Los Angeles, CA",
         endLocation: "San Francisco, CA",
         startDate: "20/09/2024",
         endDate: "23/09/2024",
         todoItems: ["Visit the Golden Gate Bridge", "Take a city tour", "Watch a movie in Hollywood"],
         expenses: [
            Expense(name: "Tour Bus", amount: 75.0),
            Expense(name: "Museum Tickets", amount: 50.0),
            Expense(name: "Lunch at Pier 39", amount: 60.0)
         ]),
    
    Trip(tripName: "Desert Safari",
         startLocation: "Las Vegas, NV",
         endLocation: "Phoenix, AZ",
         startDate: "05/10/2024",
         endDate: "10/10/2024",
         todoItems: ["Dune bashing", "Visit the Grand Canyon", "Camel ride"],
         expenses: [
            Expense(name: "Jeep Rental", amount: 300.0),
            Expense(name: "Hotel in Phoenix", amount: 500.0),
            Expense(name: "Grand Canyon Tour", amount: 100.0)
         ]),
    
    Trip(tripName: "Wine Tasting Tour",
         startLocation: "Napa Valley, CA",
         endLocation: "Sonoma, CA",
         startDate: "15/10/2024",
         endDate: "17/10/2024",
         todoItems: ["Visit vineyards", "Wine tasting", "Gourmet dinner"],
         expenses: [
            Expense(name: "Wine Tasting Fees", amount: 200.0),
            Expense(name: "Luxury Hotel", amount: 600.0),
            Expense(name: "Private Chauffeur", amount: 150.0)
         ]),
    Trip(tripName: "Historical Tour",
         startLocation: "Boston, MA",
         endLocation: "Philadelphia, PA",
         startDate: "25/10/2024",
         endDate: "30/10/2024",
         todoItems: ["Visit Independence Hall", "Tour the Liberty Bell", "Walk the Freedom Trail"],
         expenses: [
            Expense(name: "Train Tickets", amount: 100.0),
            Expense(name: "Museum Passes", amount: 50.0),
            Expense(name: "Colonial Tour", amount: 75.0)
         ]),
    
    Trip(tripName: "Ski Adventure",
         startLocation: "Salt Lake City, UT",
         endLocation: "Park City, UT",
         startDate: "05/12/2024",
         endDate: "12/12/2024",
         todoItems: ["Skiing", "Snowboarding", "Hot tub relaxation"],
         expenses: [
            Expense(name: "Ski Pass", amount: 300.0),
            Expense(name: "Snowboard Rental", amount: 150.0),
            Expense(name: "Mountain Lodge", amount: 1000.0)
         ]),
    Trip(tripName: "European Vacation",
         startLocation: "Paris, France",
         endLocation: "Rome, Italy",
         startDate: "01/11/2024",
         endDate: "15/11/2024",
         todoItems: ["Visit the Eiffel Tower", "Tour the Colosseum", "Gondola ride in Venice"],
         expenses: [
            Expense(name: "Flight to Europe", amount: 1200.0),
            Expense(name: "Eiffel Tower Tickets", amount: 40.0),
            Expense(name: "Gondola Ride", amount: 80.0)
         ])
]



class AddTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TripName: UITextField!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var todoTable: UITableView!

    var currentTrip: Trip = Trip(tripName: "", startLocation: "", endLocation: "", startDate: "", endDate: "", todoItems: [], expenses: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        startDate.date = Date()
        endDate.date = Date()
        todoTable.dataSource = self
        todoTable.delegate = self
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Pop the view controller when the alert is dismissed (if trip saved successfully)
            if message == "Trip saved successfully!" {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func OnSave(_ sender: Any) {
        guard let tripName = TripName.text, !tripName.isEmpty,
              let startLocation = startLocation.text, !startLocation.isEmpty,
              let endLocation = endLocation.text, !endLocation.isEmpty else {
            showAlert(message: "Please enter all the field details")
            return
        }

        let formattedStartDate = formatDate(date: startDate.date)
        let formattedEndDate = formatDate(date: endDate.date)

        // Update currentTrip with the entered data
        currentTrip.tripName = tripName
        currentTrip.startLocation = startLocation
        currentTrip.endLocation = endLocation
        currentTrip.startDate = formattedStartDate
        currentTrip.endDate = formattedEndDate

        // Append the current trip to the trips array
        trips.append(currentTrip)

        // Show success message, which will trigger the navigation back
        showAlert(message: "Trip saved successfully!")
    }

    @IBAction func OnAddTodo(_ sender: Any) {
        let alert = UIAlertController(title: "New Todo", message: "Enter a new todo item", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Todo item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let todoText = alert.textFields?.first?.text, !todoText.isEmpty {
                self.currentTrip.todoItems.append(todoText)
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
        currentTrip.todoItems.removeAll()
        todoTable.reloadData()
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTrip.todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        cell.todoItem.text = currentTrip.todoItems[indexPath.row]
        return cell
    }
}
