//
//  Models.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/13/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

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
    
    init(with dictionary: [String: Any]) {
        mag = dictionary["mag"] as? Double ?? Double.nan
        place = dictionary["place"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        time = dictionary["time"] as? Double ?? Double.nan
        updated = dictionary["updated"] as? Double ?? Double.nan
        tz = dictionary["tz"] as? Int ?? EarthQuakeConstants.APIMetaData.defaultEmptyInt
        url = dictionary["url"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        detail = dictionary["detail"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        felt = dictionary["felt"] as? Int ?? EarthQuakeConstants.APIMetaData.defaultEmptyInt
        cdi = dictionary["cdi"] as? Double ?? Double.nan
        mmi = dictionary["mmi"] as? Double ?? Double.nan
        alert = dictionary["alert"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        status = dictionary["status"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        tsunami = dictionary["tsunami"] as? Int ?? EarthQuakeConstants.APIMetaData.defaultEmptyInt
        sig = dictionary["sig"] as? Int ?? EarthQuakeConstants.APIMetaData.defaultEmptyInt
        net = dictionary["net"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        code = dictionary["code"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        ids = dictionary["ids"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        sources = dictionary["sources"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        types = dictionary["types"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        nts = dictionary["nts"] as? Int ?? EarthQuakeConstants.APIMetaData.defaultEmptyInt
        dmin = dictionary["dmin"] as? Double ?? Double.nan
        rms = dictionary["rms"] as? Double ?? Double.nan
        gap = dictionary["gap"] as? Double ?? Double.nan
        magType = dictionary["magType"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
        type = dictionary["type"] as? String ?? EarthQuakeConstants.APIMetaData.defaultEmptyString
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
        longitude = array[EarthQuakeConstants.APIMetaData.EQCoordinates.longitude]
        latitude = array[EarthQuakeConstants.APIMetaData.EQCoordinates.latitude]
        depth = array[EarthQuakeConstants.APIMetaData.EQCoordinates.depth]
    }
}
