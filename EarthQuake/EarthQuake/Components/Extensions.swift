//
//  Extensions.swift
//  EarthQuake
//
//  Created by Ken Cluff on 2/14/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

extension UISplitViewController {
    var detailViewController: SecondViewController? {
        guard let detailNav = detailNavigationController else { return nil }
        let detailController = detailNav.viewControllers[0] as! SecondViewController
        return detailController
    }
    
    var detailNavigationController: UINavigationController? {
        guard self.viewControllers.count > 1 else { return nil }
        return self.viewControllers[1] as? UINavigationController
    }
    
    var masterNavigationController: UINavigationController {
        let masterController = self.viewControllers[0] as! UINavigationController
        return masterController
    }
}
