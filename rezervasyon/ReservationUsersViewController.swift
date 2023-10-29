//import Foundation
//import Firebase
//import FirebaseFirestore
//
//class ReservationUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    // Constants
//    private let courseCellIdentifier = "courseCell"
//    var userIDs: [String] = []
//
//    // Variables
//    var courses: [Course] = []
//
//    // UI Components
//    private var tableView: UITableView!
//
//    // MARK: - View Lifecycle
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchCourses()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//
//    // MARK: - UI Setup
//    private func setupUI() {
//        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: courseCellIdentifier)
//        view.addSubview(tableView)
//    }
//
//    // MARK: - Data Fetching
//    func fetchCourses() {
//        let db = Firestore.firestore()
//        db.collection("courses").getDocuments { [weak self] (querySnapshot, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Error fetching courses: \(error.localizedDescription)")
//                return
//            }
//
//            self.courses = querySnapshot?.documents.compactMap { document in
//                return Course(document: document)
//            } ?? []
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    // MARK: - UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return courses.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: courseCellIdentifier, for: indexPath)
//        let course = courses[indexPath.row]
//        cell.textLabel?.text = course.courseName
//        return cell
//    }
//
//    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let selectedCourse = courses[indexPath.row]
//        let usersListVC = ReservedUsersListViewController()
//        usersListVC.userIDs = selectedCourse.reservedUserIDs
//        self.navigationController?.pushViewController(usersListVC, animated: true)
//    }
//
//
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            confirmDeleteCourse(at: indexPath.row)
//        }
//    }
//
//    // MARK: - Course Deletion
//    func confirmDeleteCourse(at index: Int) {
//        let alert = UIAlertController(title: "Ders Silme", message: "Bu dersi silmek istediğinizden emin misiniz?", preferredStyle: .alert)
//
//        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
//            self?.deleteCourse(at: index)
//        }
//
//        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
//
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func deleteCourse(at index: Int) {
//        let db = Firestore.firestore()
//        let courseID = courses[index].id
//
//        db.collection("courses").document(courseID).delete() { [weak self] error in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error deleting course: \(error.localizedDescription)")
//                    return
//                }
//
//                self.courses.remove(at: index)
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
import Foundation
import Firebase
import FirebaseFirestore

class ReservationUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Constants
    private let courseCellIdentifier = "courseCell"

    // Variables
    var courses: [Course] = []

    // UI Components
    private var tableView: UITableView!

    // Helpers
    private let uiHelper = UIDesignHelper()
    private let dataFetcher = CoursesDataFetcher()
    private let deletionHelper = CourseDeletionHelper()

    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCourses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        tableView = uiHelper.setupTableView(bounds: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    // MARK: - Data Fetching
    private func fetchCourses() {
        dataFetcher.fetchCourses { [weak self] fetchedCourses in
            self?.courses = fetchedCourses
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseCellIdentifier, for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.courseName
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // ... Your didSelectRowAt logic goes here
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteCourse(at: indexPath.row)
        }
    }

    // MARK: - Course Deletion
    private func confirmDeleteCourse(at index: Int) {
        let alert = UIAlertController(title: "Ders Silme", message: "Bu dersi silmek istediğinizden emin misiniz?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            self?.deleteCourse(at: index)
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func deleteCourse(at index: Int) {
        let courseID = courses[index].id
        deletionHelper.deleteCourse(courseID: courseID) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.courses.remove(at: index)
                    self?.tableView.reloadData()
                } else {
                    // Handle error if needed
                }
            }
        }
    }
}
