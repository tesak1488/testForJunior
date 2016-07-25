//
//  ChooseVIewController.swift
//  TUTU
//
//  Created by tesak1488 on 23.07.16.
//  Copyright © 2016 tesak1488. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {
    
    @IBOutlet var stationFromLabel: UILabel!
    @IBOutlet weak var stationToLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        stationToLabel.text = Info.stationTo
        stationFromLabel.text = Info.stationFrom
        dateLabel.text = Info.date
    }
}
