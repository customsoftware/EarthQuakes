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

struct EQData: Codable {
    let type: String
    let metadata: EQMetaData
    let features: [EQFeature]
    let bbox: [Double]
}

struct EQMetaData: Codable {
    let generated: Int64
    let url: String
    let title: String
    let api: String
    let count: Int
    let status: Int
}

struct EQFeature: Codable {
    let type: String
    let properties: EQProperties
    let geometry: EQGeometry
    let id: String
    
    init(with dictionary: [String: Any]) {
        type = dictionary["type"] as! String
        id = dictionary["id"] as! String
        let geoDictionary = dictionary["geometry"] as! [String: Any]
        geometry = EQGeometry(with: geoDictionary)
        let propertyDictionary = dictionary["properties"] as! [String: Any]
        properties = EQProperties(with: propertyDictionary)
    }
}

struct EQProperties: Codable {
    let mag: Double
    let place: String
    private let time: Double
    private let updated: Double
    let tz: Int
    let url: String
    let detail: String
    let felt: Int
    let cdi: Double
    let mmi: Double
    let alert: String
    let status: String
    let tsunami: Int
    let sig: Int
    let net: String
    let code: String
    let ids: String
    let sources: String
    let types: String
    let nts: Int
    let dmin: Double
    let rms: Double
    let gap: Double
    let magType: String
    let type: String
    var eventTime: Date {
        return Date(timeIntervalSince1970: time/1000)
    }
    var lastUpdated: Date {
        return Date(timeIntervalSince1970: updated/1000)
    }
    lazy var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    init(with dictionary: [String: Any]) {
        mag = dictionary["mag"] as? Double ?? Double.nan
        place = dictionary["place"] as? String ?? ""
        time = dictionary["time"] as? Double ?? Double.nan
        updated = dictionary["updated"] as? Double ?? Double.nan
        tz = dictionary["tz"] as! Int
        url = dictionary["url"] as? String ?? ""
        detail = dictionary["detail"] as? String ?? ""
        felt = dictionary["felt"] as? Int ?? 0
        cdi = dictionary["cdi"] as? Double ?? Double.nan
        mmi = dictionary["mmi"] as? Double ?? Double.nan
        alert = dictionary["alert"] as? String ?? ""
        status = dictionary["status"] as? String ?? ""
        tsunami = dictionary["tsunami"] as! Int
        sig = dictionary["sig"] as! Int
        net = dictionary["net"] as? String ?? ""
        code = dictionary["code"] as? String ?? ""
        ids = dictionary["ids"] as? String ?? ""
        sources = dictionary["sources"] as? String ?? ""
        types = dictionary["types"] as? String ?? ""
        nts = dictionary["nts"] as? Int ?? 0
        dmin = dictionary["dmin"] as? Double ?? Double.nan
        rms = dictionary["rms"] as? Double ?? Double.nan
        gap = dictionary["gap"] as? Double ?? Double.nan
        magType = dictionary["magType"] as? String ?? ""
        type = dictionary["type"] as? String ?? ""
    }
}

struct EQGeometry: Codable {
    let type: String
    let coordinates: EQGeometryCoordinate
    
    init(with dictionary: [String: Any]) {
        type = dictionary["type"] as! String
        let coordinateArray = dictionary["coordinates"] as! [Double]
        coordinates = EQGeometryCoordinate(with: coordinateArray)
    }
}

struct EQGeometryCoordinate: Codable {
    let longitude: Double
    let latitude: Double
    let depth: Double
    
    init(with array: [Double]) {
        longitude = array[0]
        latitude = array[1]
        depth = array[2]
    }
}
