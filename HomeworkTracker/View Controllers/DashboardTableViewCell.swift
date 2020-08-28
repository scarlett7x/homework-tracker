//
//  DashboardTableViewCell.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/28/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var classNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
