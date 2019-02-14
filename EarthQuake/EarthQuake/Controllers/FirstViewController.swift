//
//  FirstViewController.swift
//  EQ
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, ProgramBuildable {
    private var eventList = [EQFeature]()
    private var segmentControl: UISegmentedControl!
    
    var tabItem: UITabBarItem {
        let buttonImage = EQConstants.Images.home
        let retButton = UITabBarItem(title: EQConstants.Home.itemTitle, image: buttonImage, tag: 0)
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
        tableView.register(QuakeTableViewCell.self, forCellReuseIdentifier: QuakeTableViewCell.cellID)
        fetchResults(with: EQConstants.API.last30DaysURI)
        navigationItem.title = EQConstants.Home.viewTitle
        NetworkSensor.shared.addObserver(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        segmentControl.isEnabled = NetworkSensor.isConnectedToNetwork(wifiOnly: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuakeTableViewCell.cellID, for: indexPath) as! QuakeTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let summaryCell = cell as? QuakeTableViewCell else { return }
        let event = eventList[indexPath.row]
        
        summaryCell.textLabel?.text = event.properties.place
        summaryCell.textLabel?.font = EQConstants.Fonts.valueFont
        summaryCell.detailTextLabel?.text = formatter.string(from: event.properties.eventTime)
        summaryCell.detailTextLabel?.font = EQConstants.Fonts.boldCaption
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        
        guard let detailView = splitViewController?.viewControllers.last as? SecondViewController  else {
            showDetailView(with: event)
            return }
        
        detailView.controllingEvent = event
    }
    
    func createControls() {
        let searchOptions = UISegmentedControl(items: EQConstants.Home.segmentOptions)
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
}

fileprivate extension FirstViewController {
    @objc func refetchData(_ sender: UISegmentedControl) {
        guard NetworkSensor.isConnectedToNetwork(wifiOnly: false) else {
            bounceSegmentControl(sender)
            return }
        
        let selectedOption = ReportOptions.allCases[sender.selectedSegmentIndex].rawValue
        fetchResults(with: selectedOption)
        updateTitleForNewOption(sender)
    }
    
    func fetchResults(with uriString: String) {
        RESTEngine.fetchSignificantData(uri: uriString) { (events, error) in
            guard let error = error else {
                processEvents(events)
                return
            }
            var errorString = EQConstants.emptyString
            switch error {
            case RESTErrors.badURLString:
                errorString = EQConstants.Home.ErrorString.badURL
            case RESTErrors.dataDecoding, RESTErrors.dataEncoding:
                errorString = EQConstants.Home.ErrorString.coding
            case RESTErrors.noDataAvailable:
                errorString = EQConstants.Home.ErrorString.noData
                segmentControl.isEnabled = false
            case RESTErrors.unknown:
                errorString = String(format: EQConstants.Home.ErrorString.unKnown, error.localizedDescription)
            case is DecodingError:
                errorString = EQConstants.Home.ErrorString.decodeError
            default:
                errorString = String(format: EQConstants.Home.ErrorString.unKnown, error.localizedDescription)
            }
            
            throwUserAlert(with: errorString)
        }
    }
    
    func updateTitleForNewOption(_ sender: UISegmentedControl) {
        var titleString = EQConstants.Home.viewTitle
        if sender.selectedSegmentIndex == 1 {
            titleString = EQConstants.Home.altViewTitle
        }
        
        if titleString != navigationItem.title {
            navigationItem.title = titleString
            resetDetailView()
        }
    }
    
    func resetDetailView() {
        guard let detail = splitViewController?.viewControllers.last as? SecondViewController else { return }
        detail.controllingEvent = nil
    }
    
    func bounceSegmentControl(_ sender: UISegmentedControl) {
        sender.isEnabled = false
        guard let senderOption = ReportOptionIndex(rawValue: sender.selectedSegmentIndex) else { return }
        switch senderOption {
        case .major:
            sender.selectedSegmentIndex = ReportOptionIndex.significant.rawValue
        case .significant:
            sender.selectedSegmentIndex = ReportOptionIndex.major.rawValue
        }
    }
    
    func processEvents(_ events: [EQFeature]?) {
        guard let events = events else { return }
        eventList = events
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func throwUserAlert(with alertString: String) {
        let alert = UIAlertController(title: EQConstants.Home.alertTitle, message: alertString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: EQConstants.Home.okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDetailView(with event: EQFeature) {
        let detail = SecondViewController()
        detail.controllingEvent = event
        navigationController?.pushViewController(detail, animated: true)
        navigationController?.isToolbarHidden = true
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
