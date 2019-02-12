//
//  FirstViewController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import os

class FirstViewController: UITableViewController, ProgramBuildable {
    var tabItem: UITabBarItem {
        let buttonImage = UIImage(named: EarthQuakeConstants.ImageNames.home)
        let retButton = UITabBarItem(title: EarthQuakeConstants.HomeViewMetaData.itemTitle, image: buttonImage, tag: 0)
        return retButton
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        positionControls()
    }
    
    func createControls() {
        os_log(OSLogType.info, "Here is where we build the controls for the %{public}@ view", EarthQuakeConstants.HomeViewMetaData.itemTitle)
    }
    
    func positionControls() {
        os_log(OSLogType.info, "Here is where we set the constraints to position the controls for the %{public}@ view", EarthQuakeConstants.HomeViewMetaData.itemTitle)
    }
}

