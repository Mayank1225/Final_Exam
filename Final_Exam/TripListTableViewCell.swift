//
//  TripListTableViewCell.swift
//  Final_Exam
//
//  Created by user252704 on 8/16/24.
//

import UIKit

class TripListTableViewCell: UITableViewCell {

    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripDestination: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
