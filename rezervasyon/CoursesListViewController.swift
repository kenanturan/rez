import Foundation
import Firebase
import FirebaseFirestore

class CoursesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Constants
    private let courseCellIdentifier = "courseCell"

    // Variables
    var courses: [Course] = []
    var currentUserRole: UserRole = .user

    // UI Components
    private var tableView: UITableView!

    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.shared.fetchCurrentUser { [weak self] user in
            self?.currentUserRole = user?.role ?? .user
        }
        fetchCourses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: courseCellIdentifier)
        view.addSubview(tableView)
    }

    
    // MARK: - Data Fetching
    func fetchCourses() {
        let db = Firestore.firestore()
        db.collection("courses").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                let localizedError = String(format: NSLocalizedString("errorFetchingCourses", comment: ""), error.localizedDescription)
                print(localizedError)
                return
            }
            
            self.courses = querySnapshot?.documents.compactMap { document in
                return Course(document: document)
            } ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        let capacityText = String(format: NSLocalizedString("capacityPrefix", comment: ""), "\(course.capacity)")
        cell.detailTextLabel?.text = capacityText
        return cell
    }






    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCourse = courses[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setupCourseInfo(course: selectedCourse)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return currentUserRole == .admin
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteCourse(at: indexPath.row)
        }
    }

    // MARK: - Course Deletion
    func confirmDeleteCourse(at index: Int) {
        let alert = UIAlertController(
            title: NSLocalizedString("confirmDeleteTitle", comment: ""),
            message: NSLocalizedString("confirmDeleteMessage", comment: ""),
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .destructive) { [weak self] _ in
            self?.deleteCourse(at: index)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func deleteCourse(at index: Int) {
        let db = Firestore.firestore()
        let courseID = courses[index].id

        db.collection("courses").document(courseID).delete() { [weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting course: \(error.localizedDescription)")
                    return
                }
                
                self.courses.remove(at: index)
                self.tableView.reloadData()
                self.fetchCourses()
            }
        }
    }
}
