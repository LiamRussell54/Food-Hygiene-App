//
//  Restaurant.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 19/02/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import Foundation

/*restaurant class to create restaurants from the data
 that has been read in by the url*/
class Restaurant: Codable{

    let id: String
    let BusinessName: String
    let AddressLine1: String
    let AddressLine2: String?
    let AddressLine3: String?
    let PostCode: String
    let RatingValue: String
    let RatingDate: String
    let Longitude: String
    let Latitude: String
    let DistanceKM: String?
    
}
