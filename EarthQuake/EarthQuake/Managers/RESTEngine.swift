//
//  RESTEngine.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

typealias ResultHandler = ([EarthQuakeEvent]?, Error?) -> Void

struct EarthQuakeEvent: Codable {
    
}

struct RESTEngine {
    static func fetchSignificantData(with handler: ResultHandler) {
        DispatchQueue.global(qos: .background).async {
            // Here we get the data from the server
            
        }
    }
}
