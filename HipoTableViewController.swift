//
//  HipoTableViewController.swift
//  HipoIntern
//
//  Created by tuğçe on 26/02/16.
//  Copyright © 2016 tuğçe. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class HipoTableViewController: UITableViewController , UISearchResultsUpdating , UISearchBarDelegate {
    let myToken = "1283628897.1677ed0.abdcdc02b9604c1984f2f095d8194e37"
    var results : [JSON] = []
    var searchResults : [JSON] = []
    var searchTxt : String = ""
    var searchController : UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter a keyword"
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
        getInstagramData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        results = []
        searchResults = []
        getInstagramData()
        tableView.reloadData()
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let  searchText = searchController.searchBar.text {
            
            
            let sT = searchText.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
            searchTxt = sT
            let url = "https://api.instagram.com/v1/tags/\(sT)/media/recent?access_token=\(myToken)"
            Alamofire.request(.GET, url).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let data = json["data"].arrayValue as [JSON]? {
                           
                            self.searchResults = data
                            self.tableView.reloadData()
                            
                        }
                    }
                case .Failure:
                    print("")
                }
            }
            
            
            
        }
        
        tableView.reloadData()
        
    }
    
    func getInstagramData() {
        
        Alamofire.request(.GET, "https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=\(myToken)").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].arrayValue
                    self.results = data
                    self.tableView.reloadData()
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchResults.count
        }
        else {
            return results.count
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if ((searchController.active ? searchResults.count : results.count ) - indexPath.row) <= 1 {
            print("son")
            let url = searchController.active ? "https://api.instagram.com/v1/tags/\(searchTxt)/media/recent?access_token=\(myToken)" : "https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=\(myToken)"
            Alamofire.request(.GET, url).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let newURL = json["pagination"]["next_url"].stringValue
                      self.callForNewPage(newURL)
                       
                        
                        
                    }
                case .Failure(let error):
                    print(error)
                }
            }
            
        }
        
        
        
        
    }
    
    
    func callForNewPage(newURL : String) {
        Alamofire.request(.GET, newURL).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let datas = json["data"].arrayValue as [JSON]? {
                        //  self.results?.append(data)
                        for data in datas {
                            self.searchController.active ? self.searchResults.append(data) :  self.results.append(data)
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }

    }
  

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HipoTableViewCell
        cell.data = searchController.active ? searchResults[indexPath.row] : results[indexPath.row]
        
        return cell
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImageDetail" {
          
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let myDestinationVC = segue.destinationViewController as! ImageDetailViewController
                let data : SwiftyJSON.JSON? = searchController.active ? searchResults[indexPath.row] :  results[indexPath.row]
                let imageURL = data!["images"]["standard_resolution"]["url"].stringValue
                   print("adada\(imageURL)")
                
                myDestinationVC.imageURL = imageURL
                
            }
         
        }
        
        
    }
    
}
