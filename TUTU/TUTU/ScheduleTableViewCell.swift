//
//  ScheduleTableViewCell.swift
//  TUTU
//
//  Created by tesak1488 on 20.07.16.
//  Copyright © 2016 tesak1488. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var stationTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
