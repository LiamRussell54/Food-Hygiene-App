//
//  MapViewController.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 26/02/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //variables passed from segue
    var restaurants = [Restaurant]()
    var lat = 0.00
    var long = 0.00
    
    //map view outlet
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the map view delegate as itself
        myMapView.delegate = self
        /* sets the span location and region for the map view
         using the lat and long that had been passed from the segue */
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        //sets the map to be animated and show the users location
        myMapView.setRegion(region, animated: true)
        myMapView.showsUserLocation = true
        
        /* for each of the restaurants in the array create a custom pin that is placed on the map
         using the lat long of the business. The business name is used as the annotation title and
         the image used is decided based on the restaurants rating vale. Also the distance from the
         user to the restaraunt is converted into meters and used as the subtitle*/
        for r in restaurants{
            let annotation = CustomPin()
            let lati = Double(r.Latitude)
            let longi = Double(r.Longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lati!, longitude: longi!)
            annotation.title = r.BusinessName
            //meters used as users wouldn't be traveling KMs to their closest restaraunts 
            let meters = (r.DistanceKM! as NSString).doubleValue / 0.001
            annotation.subtitle = "Distance: \(Double(round(1000*meters)/1000))m"
            annotation.image = UIImage(named:"rated\(r.RatingValue)")
            myMapView.addAnnotation(annotation)
        }
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
