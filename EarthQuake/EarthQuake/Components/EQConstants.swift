//
//  EQConstants.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

struct EQConstants {
    static let emptyString = ""
    static let emptyInt = 0
    
    struct Images {
        static let home = UIImage(named: "first")
        static let settings = UIImage(named: "second")
        static let backGroundImage = UIImage(named: "splash")
    }
    
    struct Home {
        static let itemTitle = "Home"
        static let viewTitle = "Significant Earthquake Events"
        static let altViewTitle = "4.5+ Earthquakes"
        static let alertTitle = "Data Fetch Alert"
        static let okTitle = "OK"
        static let segmentOptions = ["Significant", "Major"]
        
        struct ErrorString {
            static let badURL = "A URL could not be built based upon the string passed in to the function. Please advise the developer for assistance."
            static let coding = "The results from the server could not be parsed. Please advise the developer for assistance."
            static let noData = "There is no network connection. Please check your device network settings. If those are good, the app will automatically fetch data as soon as the network connection is restored."
            static let unKnown = "There was an unknown error processing the request. Please advise the developer for assistance."
            static let decodeError = "There was an error decoding the stored data: %@. Please advise the developer for assistance."
        }
    }
    
    struct Detail {
        static let itemTitle = "Settings"
        static let backGroundAlpha: CGFloat = 0.4
        static let opaqueAlpha: CGFloat = 1.0
        static let notGiven = "Not given"
        static let detailLoadTimeoutInterval: TimeInterval = 60.0
        static let badNetworkMessage = "The network is very slow. Would you like to continue to wait for the page to load or switch to local only mode for display of detail data?"
        static let badNetworkCaption = "Slow Network"
        static let badNetworkContinue = "Continue Waiting"
        static let badNetworkBail = "Cancel and Switch To Local"
    }
    
    struct API {
        static let restRoot = "https://earthquake.usgs.gov/fdsnws/event/1/"
        static let last30DaysURI = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson"
        static let last30_4PlusURI = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson"
        static let archivedDataKey = "fetchedDataKey"
        
        struct Coord {
            static let longitude = 0
            static let latitude = 1
            static let depth = 2
        }
        
        struct JSON {
            static let featuresKey = "features"
            
            struct Features {
                static let typeKey = "type"
                static let idKey = "id"
                static let geometryKey = "geometry"
                static let propertiesKey = "properties"
            }
            
            struct Properties {
                static let magnitude = "mag"
                static let location = "place"
                static let whenOccured = "time"
                static let lastRecorded = "updated"
                static let timeZone = "tz"
                static let eventURL = "url"
                static let detailURL = "detail"
                static let felt = "felt"
                static let cdi = "cdi"
                static let mmi = "mmi"
                static let alertType = "alert"
                static let status = "status"
                static let tsunamiType = "tsunami"
                static let sig = "sig"
                static let net = "net"
                static let code = "code"
                static let ids = "ids"
                static let dataSources = "sources"
                static let types = "types"
                static let nts = "nts"
                static let dmin = "dmin"
                static let rms = "rms"
                static let gap = "gap"
                static let magType = "magType"
                static let type = "type"
            }
            
            struct GeometryKeys {
                static let typeKey = "type"
                static let coordinateKey = "coordinates"
            }
        }
        
        static let networkPollingDelay: TimeInterval = 1
    }
    
    struct Fonts {
        static let boldCaption = UIFont.boldSystemFont(ofSize: 16)
        static let valueFont = UIFont.systemFont(ofSize: 18)
    }
}
