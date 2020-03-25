//
//  DetailsViewController.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 19/02/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    //restaurant that is passed from the segue
    var theRestaurant: Restaurant!
    
    /* all of the labels, image and map that is needed
     to display the restaurants information */
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingDateLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var myMapView: MKMapView!
    
    //custom pin used for annotaion on the map
    let annotation = CustomPin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        
        /* sets label text from the restaurant info passed and sets the
         rating image based on the resturants rating value from -1 to 5*/
        nameLabel.text = theRestaurant?.BusinessName
        address1Label.text = theRestaurant.AddressLine1
        address2Label.text = theRestaurant.AddressLine2
        address3Label.text = theRestaurant.AddressLine3
        postcodeLabel.text = theRestaurant.PostCode
        ratingDateLabel.text = "Rating date: \(theRestaurant.RatingDate)"
        ratingImage.image = UIImage.init(imageLiteralResourceName:"fhrs_\(theRestaurant.RatingValue)_en-gb_L.jpg")
        
        //sets the span, location and region for the map view based on the lat long of the restaurant
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(theRestaurant.Latitude)!, Double(theRestaurant.Longitude)!)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        /*drops an annotation where the restaurants is and sets
         the pin image based on the restaurants rating value*/
        annotation.coordinate = location
        annotation.image = UIImage(named:"rated\(theRestaurant.RatingValue)")
        annotation.title = theRestaurant?.BusinessName
        
        //sets map as animated, sets map type and adds the annotation
        myMapView.setRegion(region, animated: true)
        myMapView.mapType = .standard
        myMapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {return nil}
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPin
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
