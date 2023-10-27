//
//  ReservedUsersListViewController2.swift
//  Pods
//
//  Created by Kenan TURAN on 26.10.2023.
//
import Foundation
import Firebase
import FirebaseFirestore
import Foundation

class ReservedUsersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let userIDCellIdentifier = "userIDCell"
    var userIDs: [String] = []

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.title = "Rezerve Kullanıcılar"

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: userIDCellIdentifier)
        view.addSubview(tableView)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userIDCellIdentifier, for: indexPath)
        cell.textLabel?.text = userIDs[indexPath.row]
        return cell
    }
}
