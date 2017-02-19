//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableview: UITableView!
    var refresher: UIRefreshControl!
    var searchText: String!
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var businessesSearch: [Business]!
    
    var locationManager = CLLocationManager()
    var latitude: String?
    var longtitude: String?
    var startLocation: CLLocation!
    let defaults = UserDefaults.standard
    var locationLatest:CLLocation!
    var choice:String = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
    
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(BusinessesViewController.refresh), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)
       
        
        
        searchBarFunc()
        
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse) {
            // User has granted autorization to location, get location
            locationManager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //latitude = String(format: "%.4f", (locationLatest.coordinate.latitude))
        //longtitude = String(format: "%.4f", (locationLatest.coordinate.longitude))
        
        locationLatest = locations[locations.count - 1]
        if self.startLocation == nil {
            self.startLocation = locationLatest
            //print ("\(startLocation.coordinate.latitude)")
            //print ("\(startLocation.coordinate.longitude)")
            defaults.set(startLocation.coordinate.latitude, forKey: "latitude")
            defaults.set(startLocation.coordinate.longitude, forKey: "longtitude")
            
            refresh()
        }
    }
    
    
    
    func searchBarFunc() {
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        
        searchBar.placeholder = "Business"
        //self.tableview.tableHeaderView = searchBar
        
        let frame = CGRect(x: 0, y: 0, width: 380, height: 70)
        let titleView = UIView(frame: frame)
        searchBar.backgroundImage = UIImage()
        searchBar.frame = frame
        //change color of Cancel Button of search bar
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
    }
    func refresh() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //print (startLocation.coordinate.longitude)
        Business.searchWithTerm(term: choice, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.businessesSearch = businesses
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableview.reloadData()
        })
        
        self.refresher.endRefreshing()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == false {
           // print("empty")
            self.choice = searchText
            
            /*self.businessesSearch = businesses.filter({ (mod) -> Bool in
                return (mod.name?.lowercased().contains(searchText.lowercased()))!
            })*/
        } else {
            self.choice = "all"
            
            //self.businessesSearch = self.businesses
        }
        //self.businesses = self.businessesSearch
        refresh()
        self.tableview.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
        self.refresher.endRefreshing()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        businessesSearch = []
        self.choice = "all"
        refresh()
        searchBarFunc()
    }
    

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: false)
    }
    
    //@available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.businessesSearch != nil {
            return businessesSearch.count
        } else {
            return 0
        }
    }
  

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    //@available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        
        cell.business = businessesSearch[indexPath.row]
    
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
