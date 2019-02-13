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
    var tabItem: UITabBarItem {
        let buttonImage = UIImage(named: EarthQuakeConstants.ImageNames.home)
        let retButton = UITabBarItem(title: EarthQuakeConstants.HomeViewMetaData.itemTitle, image: buttonImage, tag: 0)
        return retButton
    }
    
    override func loadView() {
        super.loadView()
        createControls()
        positionControls()
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: summaryCellID)
    }
    
    private var eventList = [EQFeature]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(fetchResults(_:)))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func createControls() {
        os_log(OSLogType.info, "Here is where we build the controls for the %{public}@ view", EarthQuakeConstants.HomeViewMetaData.itemTitle)
    }
    
    func positionControls() {
        os_log(OSLogType.info, "Here is where we set the constraints to position the controls for the %{public}@ view", EarthQuakeConstants.HomeViewMetaData.itemTitle)
    }
    
    @objc func fetchResults(_ sender: UIBarButtonItem) {
        RESTEngine.fetchSignificantData { (events, error) in
            guard let error = error else {
                processEvents(events)
                return
            }
            os_log(OSLogType.error, "%{public}@", error.localizedDescription)
        }
    }
    
    private func processEvents(_ events: [EQFeature]?) {
        guard let events = events else { return }
        eventList = events
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
