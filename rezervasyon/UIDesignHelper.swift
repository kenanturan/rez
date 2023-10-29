//
//  UIDesignHelper.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class UIDesignHelper {
    func setupTableView(bounds: CGRect) -> UITableView {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        return tableView
    }
}
