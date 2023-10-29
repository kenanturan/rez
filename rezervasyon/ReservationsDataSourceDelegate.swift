//
//  ReservationsDataSourceDelegate.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit
import Firebase

class ReservationsDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var reservations: [Course] = []
    
    weak var viewController: UIViewController? // Eğer ileride bu delegateten bir işlem yapmak istenirse
    
    private let reservationCellIdentifier = "reservationCell"
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reservationCellIdentifier, for: indexPath)
        let reservation = reservations[indexPath.row]
        cell.textLabel?.text = reservation.courseName
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCourse = reservations[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setupCourseInfo(course: selectedCourse)
        
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
