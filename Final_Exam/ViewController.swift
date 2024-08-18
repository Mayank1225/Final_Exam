import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addTrip: UIButton!
    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var Search: UISearchBar!
    
    var trips: [UserTrip] = []
    var filteredTrips: [UserTrip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Travel Buddy"
        
        Search.delegate = self
        tableSearch.dataSource = self
        tableSearch.delegate = self
    
        loadTrips()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrips()
    }
    
    func loadTrips() {
        let coreDataHelper = CoreDataHelper()
        trips = coreDataHelper.fetchTrips()
        
        filteredTrips = []
        tableSearch.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTrips = []
        } else {
            filteredTrips = trips.filter { trip in
                return trip.tripName?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            if filteredTrips.isEmpty {
                filteredTrips = []
                tableSearch.isHidden = false
            }
        }
        
        tableSearch.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Search.text?.isEmpty ?? true {
            return 0
        } else if filteredTrips.isEmpty {
            return 1
        } else {
            return filteredTrips.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        if filteredTrips.isEmpty {
            // Display "No results found" when there are no search results
            cell.SearchResult.text = "No results found"
            cell.selectionStyle = .none
        } else {
            let trip = filteredTrips[indexPath.row]
            cell.SearchResult.text = trip.tripName
            cell.selectionStyle = .default
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !filteredTrips.isEmpty else {
            return
        }
        
        let selectedTrip = filteredTrips[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TripDetailViewController") as? TripDetailViewController {
            detailVC.trip = selectedTrip
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @IBAction func OnAddTrip(_ sender: Any) {
    
    }
}
