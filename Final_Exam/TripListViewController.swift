//
//  TripListViewController.swift
//  Final_Exam
//
//  Created by user252704 on 8/16/24.
//

import UIKit

class TripListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var onSearch: UISearchBar!
    @IBOutlet weak var tripTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTable.dataSource = self
        tripTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTableViewCell", for: indexPath) as? TripListTableViewCell else {
            return UITableViewCell()
        }
        let trip = trips[indexPath.row]
        cell.tripName.text = trip.tripName
        cell.tripDestination.text = trip.endLocation
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = trips[indexPath.row]
            let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete the trip '\(trip.tripName)'?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                trips.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = trips[indexPath.row]
        
        // Manually create and present the TripDetailViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TripDetailViewController") as? TripDetailViewController {
            detailVC.trip = selectedTrip
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
