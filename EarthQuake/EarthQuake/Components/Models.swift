//
//  Models.swift
//  EQ
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
        type = dictionary[EQConstants.API.JSON.Features.typeKey] as! String
        id = dictionary[EQConstants.API.JSON.Features.idKey] as! String
        let geoDictionary = dictionary[EQConstants.API.JSON.Features.geometryKey] as! [String: Any]
        geometry = EQGeometry(with: geoDictionary)
        let propertyDictionary = dictionary[EQConstants.API.JSON.Features.propertiesKey] as! [String: Any]
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
        mag = dictionary[EQConstants.API.JSON.Properties.magnitude] as? Double ?? Double.nan
        place = dictionary[EQConstants.API.JSON.Properties.location] as? String ?? EQConstants.emptyString
        time = dictionary[EQConstants.API.JSON.Properties.whenOccured] as? Double ?? Double.nan
        updated = dictionary[EQConstants.API.JSON.Properties.lastRecorded] as? Double ?? Double.nan
        tz = dictionary[EQConstants.API.JSON.Properties.timeZone] as? Int ?? EQConstants.emptyInt
        url = dictionary[EQConstants.API.JSON.Properties.eventURL] as? String ?? EQConstants.emptyString
        detail = dictionary[EQConstants.API.JSON.Properties.detailURL] as? String ?? EQConstants.emptyString
        felt = dictionary[EQConstants.API.JSON.Properties.felt] as? Int ?? EQConstants.emptyInt
        cdi = dictionary[EQConstants.API.JSON.Properties.cdi] as? Double ?? Double.nan
        mmi = dictionary[EQConstants.API.JSON.Properties.mmi] as? Double ?? Double.nan
        alert = dictionary[EQConstants.API.JSON.Properties.alertType] as? String ?? EQConstants.emptyString
        status = dictionary[EQConstants.API.JSON.Properties.status] as? String ?? EQConstants.emptyString
        tsunami = dictionary[EQConstants.API.JSON.Properties.tsunamiType] as? Int ?? EQConstants.emptyInt
        sig = dictionary[EQConstants.API.JSON.Properties.sig] as? Int ?? EQConstants.emptyInt
        net = dictionary[EQConstants.API.JSON.Properties.net] as? String ?? EQConstants.emptyString
        code = dictionary[EQConstants.API.JSON.Properties.code] as? String ?? EQConstants.emptyString
        ids = dictionary[EQConstants.API.JSON.Properties.ids] as? String ?? EQConstants.emptyString
        sources = dictionary[EQConstants.API.JSON.Properties.dataSources] as? String ?? EQConstants.emptyString
        types = dictionary[EQConstants.API.JSON.Properties.types] as? String ?? EQConstants.emptyString
        nts = dictionary[EQConstants.API.JSON.Properties.nts] as? Int ?? EQConstants.emptyInt
        dmin = dictionary[EQConstants.API.JSON.Properties.dmin] as? Double ?? Double.nan
        rms = dictionary[EQConstants.API.JSON.Properties.rms] as? Double ?? Double.nan
        gap = dictionary[EQConstants.API.JSON.Properties.gap] as? Double ?? Double.nan
        magType = dictionary[EQConstants.API.JSON.Properties.magType] as? String ?? EQConstants.emptyString
        type = dictionary[EQConstants.API.JSON.Properties.type] as? String ?? EQConstants.emptyString
    }
}

struct EQGeometry: Codable {
    let type: String
    let coordinates: EQGeometryCoordinate
    
    init(with dictionary: [String: Any]) {
        type = dictionary[EQConstants.API.JSON.GeometryKeys.typeKey] as! String
        let coordinateArray = dictionary[EQConstants.API.JSON.GeometryKeys.coordinateKey] as! [Double]
        coordinates = EQGeometryCoordinate(with: coordinateArray)
    }
}

struct EQGeometryCoordinate: Codable {
    let longitude: Double
    let latitude: Double
    let depth: Double
    
    init(with array: [Double]) {
        longitude = array[EQConstants.API.Coord.longitude]
        latitude = array[EQConstants.API.Coord.latitude]
        depth = array[EQConstants.API.Coord.depth]
    }
}
