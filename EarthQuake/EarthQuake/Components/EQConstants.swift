//
//  EQConstants.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

struct EarthQuakeConstants {
    struct Images {
        static let home = UIImage(named: "first")
        static let settings = UIImage(named: "second")
        static let backGroundImage = UIImage(named: "splash")
    }
    
    struct HomeViewMetaData {
        static let itemTitle = "Home"
        static let viewTitle = "Significant Earthquake Events"
        static let altViewTitle = "4.5+ Earthquakes"
        static let alertTitle = "Data Fetch Alert"
        static let okTitle = "OK"
        
        struct ErrorString {
            static let badURL = "A URL could not be built based upon the string passed in to the function. Please advise the developer for assistance."
            static let coding = "The results from the server could not be parsed. Please advise the developer for assistance."
            static let noData = "There is no network connection. Please check your device network settings. If those are good, the app will automatically fetch data as soon as the network connection is restored."
            static let unKnown = "There was an unknown error processing the request. Please advise the developer for assistance."
            static let decodeError = "There was an error decoding the stored data: %@. Please advise the developer for assistance."
        }
    }
    
    struct SettingsViewMetaData {
        static let itemTitle = "Settings"
        static let backGroundAlpha: CGFloat = 0.4
    }
    
    struct APIMetaData {
        static let restRoot = "https://earthquake.usgs.gov/fdsnws/event/1/"
        static let last30DaysURI = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson"
        static let last30_4PlusURI = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson"
        static let archivedDataKey = "fetchedDataKey"
    }
}
