//
//  NetworkSensor.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import SystemConfiguration
import os

protocol NetworkAvailabilityWatcher {
    func networkStatusChangedTo(_ status: NetworkStatus)
}

enum NetworkStatus {
    case unavailable
    case wifi
    case available
}

class NetworkSensor {
    static var shared = NetworkSensor()
    
    private var delegates = [NetworkAvailabilityWatcher]()
    private var currentNetworkStatus = NetworkStatus.unavailable
    private var timer: Timer?
    
    func start() {
        timer = Timer(timeInterval: 15, repeats: true, block: { (timer) in
            if #available(iOS 12.0, *) {
                os_log(OSLogType.info, "timer fired")
            } else {
                // Fallback on earlier versions
            }
            let currentStatus = NetworkSensor.isConnectedToNetwork(wifiOnly: false)
            let wifiStatus = NetworkSensor.isConnectedToNetwork()
            
            let newStatus: NetworkStatus
            if !currentStatus,
                wifiStatus {
                newStatus = .wifi
            } else if currentStatus {
                newStatus = .available
            } else {
                newStatus = .unavailable
            }
            
            if newStatus != self.currentNetworkStatus {
                self.delegates.forEach({ $0.networkStatusChangedTo(newStatus) })
            }
            self.currentNetworkStatus = newStatus
        })
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func addObserver(observer: NetworkAvailabilityWatcher) {
        delegates.append(observer)
    }
    
    /**
     Tests for the presence of a network connection
     
     - Author:
     Ken Cluff
     
     - returns:
     A boolean value. True indicates there is a network, false indicates no network.
     
     - parameters:
     - wifiOnly: A boolean value. If true it tests only for the presence of a wifi network. If false, then it looks for any network (LTE, Edge etc.)
     - Version:
     1.0
     */
    static func isConnectedToNetwork(wifiOnly: Bool = true) -> Bool {
        var retValue = false
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            retValue = false
        } else {
            
            if wifiOnly {
                let isReachable = flags == .reachable
                let needsConnection = flags == .connectionRequired
                
                retValue = isReachable && !needsConnection
            } else {
                let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
                let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
                retValue = (isReachable && !needsConnection)
            }
        }
        
        return retValue
    }
}
