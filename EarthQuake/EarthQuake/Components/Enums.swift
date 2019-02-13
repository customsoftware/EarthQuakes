//
//  Enums.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

enum RESTErrors: Error {
    case unknown
    case dataEncoding
    case badURLString
    case dataDecoding
    case noDataAvailable
}

enum ReportOptions: String, CaseIterable {
    case significant = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson"
    case major = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson"
}

enum DetailViewFields: CaseIterable {
    case name
    case magnitude
    case eventDate
    case lastSenseDate
    case alert
    case latitude
    case longitude
    case depth
    
    var stringValue: String {
        var retValue = ""
        switch self {
        case .name:
            retValue = "Place"
        case .magnitude:
            retValue = "Magnitude"
        case .eventDate:
            retValue = "Date of Quake"
        case .lastSenseDate:
            retValue = "Date of latest reading"
        case .alert:
            retValue = "Alert Status"
        case .latitude:
            retValue = "Latitude of Epicenter"
        case .longitude:
            retValue = "Longitude of Epicenter"
        case .depth:
            retValue = "Depth of Epicenter"
        }
        
        return retValue
    }
}
