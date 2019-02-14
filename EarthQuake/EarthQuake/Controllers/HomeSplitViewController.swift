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
    
    convenience init(with app: AppDelegate) {
        self.init()
        let masterNav = UINavigationController(rootViewController: master)
        let detailNav = UINavigationController(rootViewController: detail)
        viewControllers = [masterNav, detailNav]
        delegate = self
        preferredDisplayMode = .allVisible
        if let nc = viewControllers.last as? UINavigationController {
            nc.topViewController?.navigationItem.leftBarButtonItem = displayModeButtonItem
        }
    }
    
    override func loadView() {
        super.loadView()
//        let masterNav = UINavigationController(rootViewController: master)
//        let detailNav = UINavigationController(rootViewController: detail)
//        viewControllers = [masterNav, detailNav]
//        delegate = self
//        preferredDisplayMode = .allVisible
//        if let nc = viewControllers.last as? UINavigationController {
//            nc.topViewController?.navigationItem.leftBarButtonItem = displayModeButtonItem
//        }
    }
}

extension HomeSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
            let _ = secondaryAsNavController.topViewController as? SecondViewController else { return false }
        return true
    }
}
