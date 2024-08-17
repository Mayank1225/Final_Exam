//
//  TodoTableViewCell.swift
//  Final_Exam
//
//  Created by user252704 on 8/16/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
