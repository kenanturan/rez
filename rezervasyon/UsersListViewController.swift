//
//  UsersListViewController.swift
//  Pods
//
//  Created by Kenan TURAN on 23.10.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UsersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [User]()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTableView()
        fetchUsers()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        view.addSubview(tableView)
    }
    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            self.users = snapshot?.documents.compactMap({
                let data = $0.data()
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let roleString = data["role"] as? String ?? "user"
                let role = UserRole(rawValue: roleString) ?? .user
                return User(uid: uid, email: email, role: role)
            }) ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
}
