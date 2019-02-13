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

    var tabItem: UITabBarItem {
        let buttonImage = EarthQuakeConstants.Images.home
        let retButton = UITabBarItem(title: EarthQuakeConstants.HomeViewMetaData.itemTitle, image: buttonImage, tag: 0)
        return retButton
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        positionControls()
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: summaryCellID)
        fetchResults(with: EarthQuakeConstants.APIMetaData.last30DaysURI)
        navigationItem.title = EarthQuakeConstants.HomeViewMetaData.viewTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    func createControls() {
        setUpToolbar()
    }
    
    func positionControls() { }
    
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
        let selectedOption = ReportOptions.allCases[sender.selectedSegmentIndex].rawValue
        fetchResults(with: selectedOption)
        var titleString = EarthQuakeConstants.HomeViewMetaData.viewTitle
        if sender.selectedSegmentIndex == 1 {
            titleString = EarthQuakeConstants.HomeViewMetaData.altViewTitle
        }
        navigationItem.title = titleString
        guard let detail = splitViewController?.viewControllers.last as? SecondViewController else { return }
        detail.createControls()
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
        let event = eventList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: summaryCellID, for: indexPath) as! SummaryTableViewCell
        cell.controllingEvent = event
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let eventCell = tableView.cellForRow(at: indexPath) as? SummaryTableViewCell,
            let event = eventCell.controllingEvent else { return }
        
        guard let detailView = splitViewController?.viewControllers.last as? SecondViewController  else {
            showDetailView(with: event)
            return }
        
        detailView.controllingEvent = eventCell.controllingEvent
        showDetailViewController(detailView, sender: nil)
    }
}

class SummaryTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    var controllingEvent: EQFeature? {
        didSet {
            guard var event = controllingEvent?.properties else { return }
            textLabel?.text = event.place
            let formatter = event.formatter
            detailTextLabel?.text = formatter.string(from: event.eventTime)
        }
    }
}
