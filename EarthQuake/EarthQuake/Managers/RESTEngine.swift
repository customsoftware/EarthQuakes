//
//  RESTEngine.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import os

typealias ResultHandler = ([EQFeature]?, Error?) -> Void

struct RESTEngine {
    
    /**
     This fetches the earthQuake data from the USGS servers. This is an asynchronous call using a closure to return data to the calling object.
     
     - Author:
     Ken Cluff
     
     - parameters:
     - uri: This is a string which is the URI the function will use to retrieve data
     - handler: This is a typealias for 'ResultHandler' that returns either an array of EQFeatures or an Error
     - Version:
     1.0
     */
    static func fetchSignificantData(uri: String, with handler: ResultHandler) {
        guard NetworkSensor.isConnectedToNetwork(wifiOnly: false) else {
            loadFromUserDefaults(handler)
            return
        }
        
        var events: [EQFeature]?
        var fetchError: Error?
        
        defer { handler(events, fetchError)}
        guard let requestURL = URL(string: uri) else {
            fetchError = RESTErrors.badURLString
            return
        }
        
        let resultString: String
        
        do {
            try resultString = String(contentsOf: requestURL)
            events = parse(resultString, fetchError: &fetchError)
            
        } catch let error {
            fetchError = error as! DecodingError
        }
    }
    
    private static func parse(_ dataString: String, fetchError:  inout Error?) -> [EQFeature]? {
        guard let resultData = dataString.data(using: .utf8) else {
            fetchError = RESTErrors.dataEncoding
            return nil
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any],
            let features = jsonObject?["features"] as? [[String: Any]] else {
                fetchError = RESTErrors.dataDecoding
                return nil
        }
        var eqEvents = [EQFeature]()
        features.forEach({
            let newFeature = EQFeature(with: $0)
            eqEvents.append(newFeature)
        })
        
        UserDefaults.standard.set(dataString, forKey: EarthQuakeConstants.APIMetaData.archivedDataKey)
        UserDefaults.standard.synchronize()
        return eqEvents
    }
    
    private static func loadFromUserDefaults(_ handler: ResultHandler) {
        var events: [EQFeature]?
        var fetchError: Error?
        
        if let dataString = UserDefaults.standard.string(forKey: EarthQuakeConstants.APIMetaData.archivedDataKey) {
            events = parse(dataString, fetchError: &fetchError)
        } else {
            fetchError = RESTErrors.noDataAvailable
        }
        
        handler(events, fetchError)
    }
}
