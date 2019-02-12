//
//  SecondViewController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, ProgramBuildable {
    var tabItem: UITabBarItem {
        let buttonImage = UIImage(named: EarthQuakeConstants.ImageNames.settings)
        let retButton = UITabBarItem(title: EarthQuakeConstants.SettingsViewMetaData.itemTitle, image: buttonImage, tag: 1)
        return retButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

