//
//  ReservationsViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 26.10.2023.
//

import Foundation
import UIKit
import Firebase

class ReservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Rezervasyonlarınızı burada saklayın, örneğin bir dizi olarak.
    var reservations: [Course] = [] // Kursları rezervasyonlarla değiştirin

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView'ı ayarlayın
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reservationCell")

        // TableView'ı görünüme ekleyin
        view.addSubview(tableView)

        // TableView'ı doğrudan görünümün sınırlarına ayarlayın
        tableView.frame = self.view.bounds

        // Kullanıcının yapmış olduğu rezervasyonları 'reservations' dizisine ekleyin.
        fetchUserReservations { [weak self] reservations in
            self?.reservations = reservations
            self?.tableView.reloadData()
        }
    }



    // Kullanıcının yapmış olduğu rezervasyonları getiren bir işlev ekleyin.
    func fetchUserReservations(completion: @escaping ([Course]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        let db = Firestore.firestore()
        db.collection("courses").whereField("reservedUserIDs", arrayContains: currentUserID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Rezervasyonları getirirken hata oluştu: \(error.localizedDescription)")
                completion([])
                return
            }

            var userReservations: [Course] = []

            for document in querySnapshot?.documents ?? [] {
                if let course = Course(document: document) {
                    userReservations.append(course)
                }
            }

            completion(userReservations)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Kullanıcının yapmış olduğu rezervasyonları 'reservations' dizisine ekleyin.
        fetchUserReservations { [weak self] reservations in
            self?.reservations = reservations
            self?.tableView.reloadData()
        }
    }


    // UITableViewDataSource metodları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath)
        let reservation = reservations[indexPath.row]
        cell.textLabel?.text = reservation.courseName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCourse = reservations[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setupCourseInfo(course: selectedCourse)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


}
