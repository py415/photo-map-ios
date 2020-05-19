//
//  LocationsViewController.swift
//  Photo Map
//
//  Created by Timothy Lee on 10/20/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

// ----- TODO: Add protocol to communicate with PhotoMapViewController

class LocationsViewController: UIViewController {
    
    // ––––– TODO: Add delegate
    
    // ––––– TODO: Fill in actual CLIENT_ID and CLIENT_SECRET
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private let clientId = Constant.clientId
    private let clientSecret = Constant.clientSecret
    
    private var results: NSArray = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set class as data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func fetchLocations(_ query: String, near: String = "San Francisco") {
        
        let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
        let queryString = "client_id=\(clientId)&client_secret=\(clientSecret)&v=20141020&near=\(near),CA&query=\(query)"
        let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let request = URLRequest(url: url)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, _, _) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.results = responseDictionary.value(forKeyPath: "response.venues") as! NSArray
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        task.resume()
        
    }
    
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        
        cell.location = results[(indexPath as NSIndexPath).row] as? NSDictionary
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    //What to do when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This is the selected venue
        let venue = results[(indexPath as NSIndexPath).row] as! NSDictionary
        
        // Lat and lng of venue selected
        let lat = venue.value(forKeyPath: "location.lat") as! NSNumber
        let lng = venue.value(forKeyPath: "location.lng") as! NSNumber
        
        /*-------TODO--------*/
        //Set the latitude and longitude of the venue and send it to the protocol
        
        // Return to the PhotoMapViewController with the lat and lng of venue
        
        let latString = "\(lat)"
        let lngString = "\(lng)"
        
        print(latString + " " + lngString)
        
    }
    
}

extension LocationsViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate Section
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        
        fetchLocations(newText)
        
        return true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchLocations(searchBar.text!)
        
    }
    
}
