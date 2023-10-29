//
//  ReservationsViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation


import UIKit
import Firebase

class ReservationsViewController: UIViewController {

    private var reservations: [Course] = []
    
    private let uiSetup = ReservationsUISetup()
    private let dataSourceDelegate = ReservationsDataSourceDelegate()
    private let dataFetcher = ReservationsDataFetching()

    private lazy var tableView: UITableView = {
        let table = uiSetup.createTableView()
        table.dataSource = dataSourceDelegate
        table.delegate = dataSourceDelegate
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSourceDelegate.viewController = self
        
        // TableView'ı görünüme ekleyin
        view.addSubview(tableView)

        // TableView'ı doğrudan görünümün sınırlarına ayarlayın
        tableView.frame = self.view.bounds
        
        fetchDataAndUpdateUI()
    }

    private func fetchDataAndUpdateUI() {
        dataFetcher.fetchUserReservations { [weak self] reservations in
            self?.reservations = reservations
            self?.dataSourceDelegate.reservations = reservations
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataAndUpdateUI()
    }
}
