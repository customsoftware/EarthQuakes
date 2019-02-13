//
//  Protocols.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

protocol ProgramBuildable {
    var tabItem: UITabBarItem { get }
    func createControls()
}
