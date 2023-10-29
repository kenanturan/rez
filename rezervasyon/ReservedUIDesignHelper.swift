//
//  ReservedUIDesignHelper.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class ReservedUIDesignHelper {
    
    func setupUserTableView(bounds: CGRect) -> UITableView {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userIDCell")
        return tableView
    }
    
    // Eğer diğer özel UI tasarımlarınız varsa, onları da bu sınıfa ekleyebilirsiniz.
}
