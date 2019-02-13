//
//  HomeSplitViewController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class HomeSplitViewController: UISplitViewController {
    
    private let master = FirstViewController()
    private let detail = SecondViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [master, detail]
        
        
    }
}
