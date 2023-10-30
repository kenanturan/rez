import Foundation
import Firebase
import FirebaseFirestore

class ReservedUsersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let userIDCellIdentifier = "userIDCell"
    var userIDs: [String] = []
    var userEmails: [String] = []

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserEmails()
    }

    func fetchUserEmails() {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        
        for userID in userIDs {
            group.enter()
            db.collection("users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists, let data = document.data() {
                    let email = data["email"] as? String ?? ""
                    self.userEmails.append(email)
                } else {
                    self.userEmails.append("E-posta bulunamadı")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
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
        return userEmails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userIDCellIdentifier, for: indexPath)
        cell.textLabel?.text = userEmails[indexPath.row]
        return cell
    }
}
