//
//  UserReservationsViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 26.10.2023.
//

import Foundation
import UIKit
import Firebase

class UserReservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var courses: [Course] = []
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReservations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchReservations()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        title = "Rezervasyonlarım"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func fetchReservations() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("courses").whereField("reservedUserIDs", arrayContains: currentUserID).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting reservations: \(error)")
            } else {
                self?.courses.removeAll()
                for document in snapshot!.documents {
                    if let course = Course(document: document) {
                        self?.courses.append(course)
                    }
                    self?.tableView.reloadData()
                }
            }
        }
    }
        
        // MARK: - TableView DataSource and Delegate Methods
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].courseName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCourse = courses[indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.setupCourseInfo(course: selectedCourse)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
