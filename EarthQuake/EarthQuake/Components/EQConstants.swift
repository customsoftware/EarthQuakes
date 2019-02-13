//
//  EQConstants.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

struct EarthQuakeConstants {
    struct ImageNames {
        static let home = "first"
        static let settings = "second"
    }
    
    struct HomeViewMetaData {
        static let itemTitle = "Home"
    }
    
    struct SettingsViewMetaData {
        static let itemTitle = "Settings"
    }
    
    struct APIMetaData {
        static let restRoot = "https://earthquake.usgs.gov/fdsnws/event/1/"
        static let last30DaysURI = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson"
    }
}
