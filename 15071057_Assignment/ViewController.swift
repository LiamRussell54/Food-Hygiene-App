//
//  ViewController.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 19/02/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //the ammount of rows is based on the size of the restaurant array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRestaurants.count
    }
    /*creates a cell for each restaurant, using business name
     and rating value to fill the cell content*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RestarauntTableViewCell
        cell.restarauntLabel.text = allRestaurants[indexPath.row].BusinessName
        cell.ratingImage.image = UIImage.init(imageLiteralResourceName:"fhrs_\(allRestaurants[indexPath.row].RatingValue)_en-gb.jpg")
        return cell
    }
    
    var allRestaurants = [Restaurant]()
    var latitude = 0.00
    var longitude = 0.00
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    //outets for hte table view and label to show users location
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from user
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        //if permission granted, config and start the location manager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self 
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        // get location on startup
        latitude = (locationManager.location?.coordinate.latitude)!
        longitude = (locationManager.location?.coordinate.longitude)!
        
        //update the label that displays the users current location
        updateLocationLabel()
        //load restaurants near user based on their long lat on start up
        loadRestaraunts(lat:latitude, long:longitude)
        
        //set table views data source and delegate
        myTableView.dataSource = self
        myTableView.delegate = self
        
    }
    
    func loadRestaraunts(lat: Double, long: Double ) {
        //url to recieve data from, using lat and long passed
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(lat)&long=\(long)")
        
        URLSession.shared.dataTask(with: url!) {(data, respnse, error) in
            
            guard let data = data else { print("error with data"); return}
            do{
                self.allRestaurants = try JSONDecoder().decode([Restaurant].self, from: data);
                //interupt main thread, update table with data recieved
                DispatchQueue.main.async {
                    self.myTableView.reloadData();
                }
            } catch let err {
                print("Error:", err)
            }
            
            }.resume()//start network call
    }
    
    
    /*when user has moved outside the distance filter,
    get new long lat and reload nearby restaurant and update the location label*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = (locationManager.location?.coordinate.latitude)!
        longitude = (locationManager.location?.coordinate.longitude)!
        
        loadRestaraunts(lat:latitude, long:longitude)
        updateLocationLabel()
    }
    
    //reverse geo-coding
    func updateLocationLabel() {
        geocoder.reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error) in
            if error == nil {
                //take the first location and gets its locality and country
                let firstLocation = placemarks?[0]
                let locality = firstLocation?.locality
                let country = firstLocation?.country
                //set labels text to users location
                self.locationLabel?.text = "Location: \(locality!) , \(country!)"
            }
            else {
                //error occured during geocoding
                if let error = error{
                    print("error with reverse geo-coding \n \(error)")
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //check to see if a table view cell is the sender
        if let cell = sender as? UITableViewCell{
            let i = myTableView.indexPath(for: cell)!.row
            /*if the segue id is details set the location as details view controller
            and pass the restaurant that was clicked by the user in the table view*/
            if segue.identifier == "details"{
                let dvc = segue.destination as! DetailsViewController
                dvc.theRestaurant = self.allRestaurants[i]
            }
        }
        
        /*if the segue id is map set the destiantion as the map view controller
         and pass over the restaurants array along with the users lat long*/
        if segue.identifier == "map"{
            let mvc = segue.destination as! MapViewController
            mvc.restaurants = self.allRestaurants
            mvc.lat = latitude
            mvc.long = longitude
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

