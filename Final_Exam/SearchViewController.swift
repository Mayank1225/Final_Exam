//
//  SearchViewController.swift
//  Final_Exam
//
//  Created by user252704 on 8/18/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    var filteredTrips: [UserTrip] = []
    var selectionHandler: ((UserTrip) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    private func setupButtons() {
        // Dynamically create buttons based on the filteredTrips
        for (index, trip) in filteredTrips.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(trip.tripName ?? "Unknown Trip", for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            // Add button to the view (use constraints or frame to position)
            view.addSubview(button)
            
            // Set up the button layout (for simplicity using frame, but Auto Layout is preferred)
            button.frame = CGRect(x: 20, y: 50 + (index * 50), width: 300, height: 40)
        }
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        let selectedTrip = filteredTrips[sender.tag]
        dismiss(animated: true) {
            self.selectionHandler?(selectedTrip)
        }
    }
}

