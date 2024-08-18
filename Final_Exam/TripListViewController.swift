import UIKit
import CoreData

class TripListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var onSearch: UISearchBar!
    @IBOutlet weak var tripTable: UITableView!

    var trips: [UserTrip] = []
    var filteredTrips: [UserTrip] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tripTable.dataSource = self
        tripTable.delegate = self
        onSearch.delegate = self
        loadTrips()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrips()
    }

    func loadTrips() {
        let coreDataHelper = CoreDataHelper()
        trips = coreDataHelper.fetchTrips()
        filteredTrips = trips
        tripTable.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTrips.isEmpty ? 1 : filteredTrips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTableViewCell", for: indexPath) as? TripListTableViewCell else {
            return UITableViewCell()
        }
        
        if filteredTrips.isEmpty {
            cell.tripName.text = "No trips available. Please click to add trip"
            cell.tripDestination.text = ""
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
        } else {
            let trip = filteredTrips[indexPath.row]
            cell.tripName.text = trip.tripName
            cell.tripDestination.text = trip.endLocation
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !filteredTrips.isEmpty && editingStyle == .delete {
            let trip = filteredTrips[indexPath.row]
            let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete the trip '\(trip.tripName ?? "")'?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Delete the trip from Core Data
                let coreDataHelper = CoreDataHelper()
                coreDataHelper.deleteTrip(trip: trip)
                
                // Remove from the original trips array
                if let index = self.trips.firstIndex(of: trip) {
                    self.trips.remove(at: index)
                }

                // Remove from the filtered list
                self.filteredTrips.remove(at: indexPath.row)
                
                if self.filteredTrips.isEmpty {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredTrips.isEmpty {
            // Navigate to AddTripViewController if no trips are available
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addTripVC = storyboard.instantiateViewController(withIdentifier: "AddTripViewController") as? AddTripViewController {
                navigationController?.pushViewController(addTripVC, animated: true)
            }
        } else {
            let selectedTrip = filteredTrips[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "TripDetailViewController") as? TripDetailViewController {
                detailVC.trip = selectedTrip
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTrips = trips
        } else {
            filteredTrips = trips.filter { trip in
                return trip.tripName?.lowercased().contains(searchText.lowercased()) ?? false ||
                       trip.endLocation?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        tripTable.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredTrips = trips
        tripTable.reloadData()
        searchBar.resignFirstResponder()
    }
}
