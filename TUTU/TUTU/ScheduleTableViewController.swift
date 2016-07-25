//
//  ScheduleTableViewController.swift
//  TUTU
//
//  Created by tesak1488 on 20.07.16.
//  Copyright © 2016 tesak1488. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var stations = [Station]()
    var filteredStations = [Station]()
    var stationCityTitles = [String]()
    var groupedStations  = [[Station]]()
    var resultsSearchController = UISearchController(searchResultsController: nil)
    
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
                self.makeStationsGrouped()
                NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in self.tableView.reloadData()})
            }
        })
        task.resume()
        resultsSearchController.searchBar.delegate = self
        resultsSearchController.searchResultsUpdater = self
        resultsSearchController.dimsBackgroundDuringPresentation = false
        resultsSearchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = resultsSearchController.searchBar
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if resultsSearchController.active {
            return 1
        } else {
            return groupedStations.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultsSearchController.active {
            return nil
        } else {
            return stationCityTitles[section]
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultsSearchController.active {
            return filteredStations.count
        } else {
            return groupedStations[section].count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ScheduleTableViewCell
        if resultsSearchController.active {
            cell.countryTitle.text = filteredStations[indexPath.row].countryTitle
            cell.stationTitle.text = filteredStations[indexPath.row].stationTitle
        } else {
            cell.countryTitle.text = groupedStations[indexPath.section][indexPath.row].countryTitle
            cell.stationTitle.text = groupedStations[indexPath.section][indexPath.row].stationTitle
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if resultsSearchController.active {
            Info.stationFrom = filteredStations[indexPath.row].stationTitle
        } else {
            Info.stationFrom = groupedStations[indexPath.section][indexPath.row].stationTitle
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let showAction = UITableViewRowAction(style: .Default, title: "Detail", handler: {
            (action, indexPath) -> Void in
            if !self.resultsSearchController.active {
                let alertAction = UIAlertController(title: "Information", message: "cityId: \(self.groupedStations[indexPath.section][indexPath.row].cityId)\n stationId: \(self.groupedStations[indexPath.section][indexPath.row].stationId)\n regionTitle: \(self.groupedStations[indexPath.section][indexPath.row].regionTitle)\n disrtictTitle: \(self.groupedStations[indexPath.section][indexPath.row].districtTitle)\n ", preferredStyle: .Alert)
                alertAction.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertAction, animated: true, completion: nil)
            } else {
                let alertAction = UIAlertController(title: "Information", message: "cityId: \(self.filteredStations[indexPath.row].cityId)\n stationId: \(self.filteredStations[indexPath.row].stationId)\n regionTitle: \(self.filteredStations[indexPath.row].regionTitle)\n disrtictTitle: \(self.filteredStations[indexPath.row].districtTitle)\n ", preferredStyle: .Alert)
                alertAction.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertAction, animated: true, completion: nil)
            }
            })
        return [showAction]
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredStations = stations.filter{ station in return station.stationTitle.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)}
        tableView.reloadData()
    }
 
    func parseJson(data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            let citiesFromList = jsonResult!["citiesFrom"] as! [AnyObject]
            for citiesFrom in citiesFromList {
                let stationsList = citiesFrom["stations"] as! [AnyObject]
                for stations in stationsList {
                    let localStation = Station()
                    localStation.countryTitle = stations["countryTitle"] as! String
                    localStation.cityTitle = stations["cityTitle"] as! String
                    localStation.point = stations["point"] as! [String: Double]
                    localStation.stationTitle = stations["stationTitle"] as! String
                    localStation.cityId = stations["cityId"] as! Int
                    localStation.regionTitle = stations["regionTitle"] as! String
                    localStation.districtTitle = stations["districtTitle"] as! String
                    localStation.stationId = stations["stationId"] as! Int
                    self.stations.append(localStation)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func makeStationsGrouped() {
        var localCityTitle = ""
        for station in stations {
            if station.cityTitle != localCityTitle {
                stationCityTitles.append(station.cityTitle)
                localCityTitle = station.cityTitle
            }
        }
        
        localCityTitle = stations[0].cityTitle
        groupedStations = [[Station]](count: stationCityTitles.count, repeatedValue: [Station](count: 0, repeatedValue: Station()))
        var i = 0
        for station in stations {
            if station.cityTitle == localCityTitle {
                groupedStations[i].append(station)
            } else {
                i += 1
                localCityTitle = station.cityTitle
                groupedStations[i].append(station)
            }
        }
    }
}
