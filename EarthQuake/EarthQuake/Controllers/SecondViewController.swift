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
    let detailCellID = "detailCellID"
    
    lazy var formatter: DateFormatter = {
        let aFormatter = DateFormatter()
        aFormatter.timeStyle = .medium
        aFormatter.dateStyle = .medium
        return aFormatter
    }()
    
    var tabItem: UITabBarItem {
        let buttonImage = EarthQuakeConstants.Images.settings
        let retButton = UITabBarItem(title: EarthQuakeConstants.SettingsViewMetaData.itemTitle, image: buttonImage, tag: 1)
        return retButton
    }
    
    var webView: WKWebView?
    var tableView: UITableView?
    var controllingEvent: EQFeature? {
        didSet {
            guard let _ = controllingEvent  else {
                resetView()
                return }
            
            if NetworkSensor.isConnectedToNetwork(wifiOnly: false) {
                makeWebView()
            } else {
                makeLocalView()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        NetworkSensor.shared.addObserver(observer: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let webView = webView {
            webView.frame.size = size
        } else if let tableView = tableView {
            tableView.frame.size = size
        }
    }
    
    func createControls() {
        guard let view = makeBackgroundView() else { return }
        self.view = view
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
            let url = URL(string: urlString),
            let frame = UIApplication.shared.windows.first?.frame else { return }
        
        let request = URLRequest(url: url)
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        let web = WKWebView(frame: frame, configuration: config)
        web.load(request)
        
        swapIn(web)
        webView = web
    }
    
    func makeLocalView() {
        guard let frame = UIApplication.shared.windows.first?.frame else { return }
        let newView = UITableView(frame: frame, style: .plain)
        newView.register(DetailTableViewCell.self, forCellReuseIdentifier: detailCellID)
        newView.dataSource = self
        newView.delegate = self
        newView.reloadData()
        
        swapIn(newView)
        tableView = newView
    }
    
    func swapIn(_ newView: UIView) {
        resetView()
        view.alpha = 1
        view.addSubview(newView)
    }
    
    func resetView() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.alpha = EarthQuakeConstants.SettingsViewMetaData.backGroundAlpha
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailViewFields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = DetailViewFields.allCases[indexPath.row]
        guard let detailCell = cell as? DetailTableViewCell,
            let event = controllingEvent else { return }
        var displayValue = ""
        
        switch key {
        case .alert:
            displayValue = event.properties.alert.isEmpty ? EarthQuakeConstants.SettingsViewMetaData.notGiven : event.properties.alert
            
        case .depth:
            displayValue = "\(event.geometry.coordinates.depth) km"
            
        case .eventDate:
            displayValue = formatter.string(from: event.properties.eventTime)
            
        case .lastSenseDate:
            displayValue = formatter.string(from: event.properties.lastUpdated)
            
        case .latitude:
            displayValue = "\(event.geometry.coordinates.latitude)"
            
        case .longitude:
            displayValue = "\(event.geometry.coordinates.longitude)"
            
        case .name:
            displayValue = event.properties.place
            
        case .magnitude:
            displayValue = "\(event.properties.mag)"
        }
        
        detailCell.textLabel?.text = displayValue
        detailCell.textLabel?.font = EarthQuakeConstants.Fonts.valueFont
        
        detailCell.detailTextLabel?.text = key.stringValue
        detailCell.detailTextLabel?.font = EarthQuakeConstants.Fonts.boldCaption
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: detailCellID, for: indexPath) as! DetailTableViewCell
    }
}

extension SecondViewController: NetworkAvailabilityWatcher {
    func networkStatusChangedTo(_ status: NetworkStatus) {
        if status != .unavailable {
            DispatchQueue.main.async {
                self.makeWebView()
            }
            NetworkSensor.shared.stop()
        }
    }
}

class DetailTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
}
