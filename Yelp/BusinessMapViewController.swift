//
//  BusinessMapViewController.swift
//  Yelp
//
//  Created by Jake Vo on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import Foundation

class BusinessMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager()
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var businessesSearch: [Business]!
    var choice: String = "all"
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        searchBarFunc()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        refresh()
        // Do any additional setup after loading the view.
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations [0]

        
       
        
        let latitudeMap: CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitudeMap: CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees =  0.06
        let lonDelta: CLLocationDegrees = 0.06
        
        
        //zoom level of the map
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeMap, longitude: longitudeMap)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapview.setRegion(region, animated: true)
        //mapview.showsUserLocation = true
        self.locationManager.stopUpdatingLocation();

        
        //refresh()
        
    }
    func refresh() {
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        self.businessesSearch = []
        
        let allAnnotations = self.mapview.annotations
        self.mapview.removeAnnotations(allAnnotations)
        //print (startLocation.coordinate.longitude)
        Business.searchWithTerm(term: self.choice, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            
            print ("choice in refresh is\(self.choice)")
            self.businesses = businesses
            self.businessesSearch = businesses
            
            //print ("\(self.businessesSearch[0].latitude)")
            //MBProgressHUD.hide(for: self.view, animated: true)
            self.searchHelper()
        })
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == false {
            let allAnnotations = self.mapview.annotations
            self.mapview.removeAnnotations(allAnnotations)
            self.choice = searchText
            
            self.businessesSearch = businesses.filter({ (mod) -> Bool in
                return (mod.name?.lowercased().contains(searchText.lowercased()))!
            })
            //self.searchHelper()
            refresh()
        } else {
            self.choice = "all"
            mapview.showsUserLocation = true
            refresh()
        }
        //refresh()
        //MBProgressHUD.hide(for: self.view, animated: true)
        
        
    }
    
    func searchHelper() {
        if self.businessesSearch != nil {
            print("how many restaurant\(self.businessesSearch.count)")
            for x in self.businessesSearch {
                let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: x.latitude, longitude: x.longitude)
                let anotation = MKPointAnnotation()
                anotation.title = x.name
                anotation.subtitle = x.address
                anotation.coordinate = location
                self.mapview.addAnnotation(anotation)
            }
        } else {
            print ("null value")
        }
        let allAnnotations = self.mapview.annotations
        var y = 0
        for x in allAnnotations {
            
            

            if (x.title!)!.lowercased().contains(self.choice.lowercased()) && self.choice.lowercased() != "all" {
                print ("choice is \(self.choice)")
                print ("title is \((x.title!)!)")
                mapview.selectAnnotation(mapview.annotations[y], animated: true)
                break
            }
            y = y + 1
        }
    }
    func searchBarFunc() {
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        
        searchBar.placeholder = "Business"
        //self.tableview.tableHeaderView = searchBar
        
        let frame = CGRect(x: 0, y: 0, width: 320, height: 70)
        let titleView = UIView(frame: frame)
        searchBar.backgroundImage = UIImage()
        searchBar.frame = frame
        //change color of Cancel Button of search bar
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
