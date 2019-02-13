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
    let summaryCellID = "summaryCellID"
    
    private var eventList = [EQFeature]()
    private var segmentControl: UISegmentedControl!
    
    var tabItem: UITabBarItem {
        let buttonImage = EarthQuakeConstants.Images.home
        let retButton = UITabBarItem(title: EarthQuakeConstants.HomeViewMetaData.itemTitle, image: buttonImage, tag: 0)
        return retButton
    }
    
    lazy var formatter: DateFormatter = {
       let aFormatter = DateFormatter()
        aFormatter.timeStyle = .medium
        aFormatter.dateStyle = .medium
        return aFormatter
    }()
    
    override func loadView() {
        super.loadView()
        createControls()
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: summaryCellID)
        fetchResults(with: EarthQuakeConstants.APIMetaData.last30DaysURI)
        navigationItem.title = EarthQuakeConstants.HomeViewMetaData.viewTitle
        NetworkSensor.shared.addObserver(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        segmentControl.isEnabled = NetworkSensor.isConnectedToNetwork(wifiOnly: false)
    }
    func createControls() {
        setUpToolbar()
    }
    
    func fetchResults(with uirString: String) {
        RESTEngine.fetchSignificantData(uri: uirString) { (events, error) in
            guard let error = error else {
                processEvents(events)
                return
            }
            var errorString = ""
            switch error {
            case RESTErrors.badURLString:
                errorString = EarthQuakeConstants.HomeViewMetaData.ErrorString.badURL
            case RESTErrors.dataDecoding, RESTErrors.dataEncoding:
                errorString = EarthQuakeConstants.HomeViewMetaData.ErrorString.coding
            case RESTErrors.noDataAvailable:
                errorString = EarthQuakeConstants.HomeViewMetaData.ErrorString.noData
                NetworkSensor.shared.start()
                segmentControl.isEnabled = false
            case RESTErrors.unknown:
                errorString = String(format: EarthQuakeConstants.HomeViewMetaData.ErrorString.unKnown, error.localizedDescription)
            case is DecodingError:
                errorString = EarthQuakeConstants.HomeViewMetaData.ErrorString.decodeError
            default:
                errorString = String(format: EarthQuakeConstants.HomeViewMetaData.ErrorString.unKnown, error.localizedDescription)
            }
            
            throwUserAlert(with: errorString)
        }
    }
    
    @objc func refetchData(_ sender: UISegmentedControl) {
        guard NetworkSensor.isConnectedToNetwork(wifiOnly: false) else {
            sender.isEnabled = false
            if sender.selectedSegmentIndex == 0 {
                sender.selectedSegmentIndex = 1
            } else {
                sender.selectedSegmentIndex = 0
            }
            return }
        let selectedOption = ReportOptions.allCases[sender.selectedSegmentIndex].rawValue
        fetchResults(with: selectedOption)
        var titleString = EarthQuakeConstants.HomeViewMetaData.viewTitle
        if sender.selectedSegmentIndex == 1 {
            titleString = EarthQuakeConstants.HomeViewMetaData.altViewTitle
        }
        if titleString != navigationItem.title {
            navigationItem.title = titleString
            guard let detail = splitViewController?.viewControllers.last as? SecondViewController else { return }
            detail.controllingEvent = nil
        }
    }
    
    private func processEvents(_ events: [EQFeature]?) {
        guard let events = events else { return }
        eventList = events
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func throwUserAlert(with alertString: String) {
        let alert = UIAlertController(title: EarthQuakeConstants.HomeViewMetaData.alertTitle, message: alertString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: EarthQuakeConstants.HomeViewMetaData.okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setUpToolbar(){
        let items = ["Last 30", "Major"]
        let searchOptions = UISegmentedControl(items: items)
        searchOptions.addTarget(self, action: #selector(refetchData(_:)), for: .valueChanged)
        searchOptions.selectedSegmentIndex = 0
        segmentControl = searchOptions
        let button = UIBarButtonItem(customView: searchOptions)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(spacer)
        toolBarItems.append(button)
        toolBarItems.append(spacer)
        
        self.setToolbarItems(toolBarItems, animated: true)
        self.navigationController?.toolbar.tintColor = .black
    }
    
    private func showDetailView(with event: EQFeature) {
        let detail = SecondViewController()
        detail.controllingEvent = event
        navigationController?.pushViewController(detail, animated: true)
        navigationController?.isToolbarHidden = true
    }
}

extension FirstViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: summaryCellID, for: indexPath) as! SummaryTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let summaryCell = cell as? SummaryTableViewCell else { return }
        let event = eventList[indexPath.row]
        
        summaryCell.textLabel?.text = event.properties.place
        summaryCell.textLabel?.font = EarthQuakeConstants.Fonts.valueFont
        
        summaryCell.detailTextLabel?.text = formatter.string(from: event.properties.eventTime)
        summaryCell.detailTextLabel?.font = EarthQuakeConstants.Fonts.boldCaption
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        
        guard let detailView = splitViewController?.viewControllers.last as? SecondViewController  else {
            showDetailView(with: event)
            return }
        
        detailView.controllingEvent = event
        showDetailViewController(detailView, sender: nil)
    }
}

extension FirstViewController: NetworkAvailabilityWatcher {
    func networkStatusChangedTo(_ status: NetworkStatus) {
        if status != .unavailable {
            refetchData(segmentControl)
        }
        segmentControl.isEnabled = NetworkSensor.isConnectedToNetwork(wifiOnly: false)
    }
}

class SummaryTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
}
