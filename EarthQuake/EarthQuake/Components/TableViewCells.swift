//
//  TableViewCells.swift
//  EarthQuake
//
//  Created by Kenneth Cluff on 2/13/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class QuakeTableViewCell: UITableViewCell {
    static let cellID = "quakeCellID"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
}
