//
//  SecondViewController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import os

class SecondViewController: UIViewController, ProgramBuildable {
    var tabItem: UITabBarItem {
        let buttonImage = UIImage(named: EarthQuakeConstants.ImageNames.settings)
        let retButton = UITabBarItem(title: EarthQuakeConstants.SettingsViewMetaData.itemTitle, image: buttonImage, tag: 1)
        return retButton
    }
    
    var presentedURLString: String?
    
    lazy var apiLabel = makeAPILabel(in: self.view)
    
    override func loadView() {
        super.loadView()
        createControls()
        positionControls()
    }
    
    func createControls() {
        guard let view = makeBackgroundView() else { return }
        self.view = view
        _ = apiLabel
    }
    
    func positionControls() {
        positionAPILabel()
        os_log(OSLogType.info, "Here is where we set the constraints to position the controls for the %{public}@ view", EarthQuakeConstants.SettingsViewMetaData.itemTitle)
    }
}

// MARK: - Create controls
fileprivate extension SecondViewController {
    func makeBackgroundView() -> UIView? {
        guard let windowFrame = UIApplication.shared.windows.first?.frame else { return nil }
        let view = UIView(frame: windowFrame)
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    func makeAPILabel(in view: UIView) -> UILabel {
        let retValue = UILabel.forAutoLayout()
        retValue.textAlignment = .left
        retValue.lineBreakMode = .byWordWrapping
        retValue.numberOfLines = 0
        retValue.text = EarthQuakeConstants.APIMetaData.restRoot
        retValue.textColor = .black
        view.addSubview(retValue)
        return retValue
    }
}

// MARK: - Position controls
fileprivate extension SecondViewController {
    func positionAPILabel() {
        apiLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        apiLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
}
