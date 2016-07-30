//
//  DateViewController.swift
//  TUTU
//
//  Created by tesak1488 on 23.07.16.
//  Copyright © 2016 tesak1488. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func ChooseDate(sender: AnyObject) {
        Info.date = String(datePicker.date)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
