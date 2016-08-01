//
//  CountriesToController.swift
//  TUTU
//
//  Created by tesak1488 on 01.08.16.
//  Copyright © 2016 tesak1488. All rights reserved.
//

import UIKit

class CountriesToController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var countries = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: "https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json")!), completionHandler: {
            (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.parseJson(data)
                NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in self.tableView.reloadData()})
            }
        })
        task.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryToCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func parseJson(data: NSData) { //getting countryTitles
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            let citiesFrom = jsonResult!["citiesFrom"] as! [AnyObject]
            var localCity = ""
            for cityFrom in citiesFrom {
                if (cityFrom["countryTitle"] as! String) != localCity {
                    countries.append(cityFrom["countryTitle"] as! String)
                    localCity = cityFrom["countryTitle"] as! String
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStations2" {
            let VC = segue.destinationViewController as! ScheduleToController
            VC.country = countries[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }
}
