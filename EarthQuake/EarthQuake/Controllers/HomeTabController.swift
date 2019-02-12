//
//  HomeTabController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {
    let firstViewController = FirstViewController()
    let secondViewController = SecondViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstViewController.tabBarItem = firstViewController.tabItem
        secondViewController.tabBarItem = secondViewController.tabItem
        
        viewControllers = [firstViewController, secondViewController]
    }
}
