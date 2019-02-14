//
//  SecondViewController.swift
//  EQ
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit
import WebKit
import os

class SecondViewController: UIViewController, ProgramBuildable {
    lazy private var formatter: DateFormatter = {
        let aFormatter = DateFormatter()
        aFormatter.timeStyle = .medium
        aFormatter.dateStyle = .medium
        return aFormatter
    }()
    
    var tabItem: UITabBarItem {
        let buttonImage = EQConstants.Images.settings
        let retButton = UITabBarItem(title: EQConstants.Detail.itemTitle, image: buttonImage, tag: 1)
        return retButton
    }
    
    private var webView: WKWebView?
    private var tableView: UITableView?
    
    var controllingEvent: EQFeature? {
        didSet {
            guard let _ = controllingEvent else {
                resetView()
                return }
            
            if NetworkSensor.isConnectedToNetwork(wifiOnly: false) {
                guard let web = makeWebView() else { return }
                self.view = web
                
            } else {
                guard let tableView = makeLocalView() else { return }
                swapIn(tableView)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        NetworkSensor.shared.addObserver(observer: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let tableView = tableView {
            tableView.frame.size = size
        }
    }
    
    func createControls() {
        guard let view = makeBackgroundView() else { return }
        self.view = view
    }
}

// MARK: - Control related
fileprivate extension SecondViewController {
    func makeBackgroundView() -> UIView? {
        guard let windowFrame = UIApplication.shared.windows.first?.frame else { return nil }
        let view = UIImageView(frame: windowFrame)
        view.image = EQConstants.Images.backGroundImage
        view.alpha = EQConstants.Detail.backGroundAlpha
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFill
        return view
    }
    
    func makeWebView() -> WKWebView? {
        guard let urlString = controllingEvent?.properties.url,
            let url = URL(string: urlString) else { return nil }
        
        let request = URLRequest(url: url)
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        let web = WKWebView(frame: .zero, configuration: config)
        web.load(request)
        webView = web
        return web
    }
    
    func makeLocalView() -> UITableView? {
        guard let frame = UIApplication.shared.windows.first?.frame else { return nil }
        let newView = UITableView(frame: frame, style: .plain)
        newView.register(QuakeTableViewCell.self, forCellReuseIdentifier: QuakeTableViewCell.cellID)
        newView.dataSource = self
        newView.delegate = self
        newView.reloadData()
        
        tableView = newView
        return newView
    }
    
    func swapIn(_ newView: UIView) {
        resetView()
        view.alpha = EQConstants.Detail.opaqueAlpha
        view.addSubview(newView)
    }
    
    func resetView() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        createControls()
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailViewFields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = DetailViewFields.allCases[indexPath.row]
        guard let detailCell = cell as? QuakeTableViewCell,
            let event = controllingEvent else { return }
        var displayValue = ""
        
        switch key {
        case .alert:
            displayValue = event.properties.alert.isEmpty ? EQConstants.Detail.notGiven : event.properties.alert
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
        detailCell.textLabel?.font = EQConstants.Fonts.valueFont
        detailCell.detailTextLabel?.text = key.stringValue
        detailCell.detailTextLabel?.font = EQConstants.Fonts.boldCaption
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: QuakeTableViewCell.cellID, for: indexPath) as! QuakeTableViewCell
    }
}

extension SecondViewController: NetworkAvailabilityWatcher {
    func networkStatusChangedTo(_ status: NetworkStatus) {
        if status != .unavailable {
            DispatchQueue.main.async {
                guard let web = self.makeWebView() else { return }
                self.view = web
            }
        }
    }
}
