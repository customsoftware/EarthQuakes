//
//  RESTEngine.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation
import os

typealias ResultHandler = ([EQFeature]?, Error?) -> Void

struct RESTEngine {
    static func fetchSignificantData(with handler: ResultHandler) {
        guard let requestURL = URL(string: EarthQuakeConstants.APIMetaData.last30DaysURI) else {
            handler(nil, RESTErrors.badURLString)
            return
        }
        
        let resultString: String
//        let jsonDecoder = JSONDecoder()
        
        do {
            try resultString = String(contentsOf: requestURL)
            guard let resultData = resultString.data(using: .utf8) else {
                handler(nil, RESTErrors.dataEncoding)
                return
            }
            var events = [EQFeature]()
            guard let jsonObject = try JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any],
                let features = jsonObject["features"] as? [[String: Any]] else { return }
            features.forEach({
                let newFeature = EQFeature(with: $0)
                events.append(newFeature)
            })
            
//            let earthQuakeData = try jsonDecoder.decode(EQData.self, from: resultData)
            handler(events, nil)
        } catch let error {
            let codeError = error as! DecodingError
            os_log(OSLogType.error, "%{public}@",codeError.localizedDescription)
            handler(nil, codeError)
        }
    }
}
