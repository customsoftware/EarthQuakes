//
//  SecondViewController.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import WebKit
import os

class SecondViewController: UIViewController, ProgramBuildable {
    var tabItem: UITabBarItem {
        let buttonImage = EarthQuakeConstants.Images.settings
        let retButton = UITabBarItem(title: EarthQuakeConstants.SettingsViewMetaData.itemTitle, image: buttonImage, tag: 1)
        return retButton
    }
    
    var webView: WKWebView?
    var controllingEvent: EQFeature? {
        didSet {
            guard let event = controllingEvent else { return }
            if NetworkSensor.isConnectedToNetwork(wifiOnly: false) {
                // Add the webview and go to the URL
                makeWebView()
            } else {
                // Load what we have archived in the event itself
                print("Loading local: \(event.properties.place)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        positionControls()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let webView = webView else { return }
        webView.frame.size = size
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let web = webView else { return }
        web.stopLoading()
        createControls()
        webView = nil
    }
    
    func createControls() {
        guard let view = makeBackgroundView() else { return }
        self.view = view
    }
    
    func positionControls() {
        if #available(iOS 12.0, *) {
            os_log(OSLogType.info, "Here is where we set the constraints to position the controls for the %{public}@ view", EarthQuakeConstants.SettingsViewMetaData.itemTitle)
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - Create controls
fileprivate extension SecondViewController {
    func makeBackgroundView() -> UIView? {
        guard let windowFrame = UIApplication.shared.windows.first?.frame else { return nil }
        let view = UIImageView(frame: windowFrame)
        view.image = EarthQuakeConstants.Images.backGroundImage
        view.alpha = EarthQuakeConstants.SettingsViewMetaData.backGroundAlpha
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFill
        return view
    }
    
    func makeWebView() {
        guard let urlString = controllingEvent?.properties.url,
            let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        let web = WKWebView(frame: .zero, configuration: config)
        web.load(request)
        web.uiDelegate = self
        view = web
    }
    
    func makeLocalView() {
        
    }
}

extension SecondViewController: WKUIDelegate {
    
}

// MARK: - Position controls
fileprivate extension SecondViewController {
    
}
