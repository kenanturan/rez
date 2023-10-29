//
//  CoursesListViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class CoursesListViewController: UIViewController {

    // Constants
    private let courseCellIdentifier = "courseCell"

    // UI Components
    private var tableView: UITableView!

    // ViewModel, DataSource & Delegate
    private var coursesViewModel = CoursesViewModel()
    private var coursesDataSource = CoursesDataSource()
    private var coursesDelegate = CoursesDelegate()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Setting up delegates, data sources and bindings
        tableView.delegate = coursesDelegate
        tableView.dataSource = coursesDataSource
        coursesDelegate.delegate = self
        
        coursesViewModel.onDataUpdated = { [weak self] in
            self?.coursesDataSource.courses = self?.coursesViewModel.courses ?? []
            self?.coursesDelegate.courses = self?.coursesViewModel.courses ?? []
            self?.tableView.reloadData()
        }

        coursesViewModel.onError = { error in
            // Handle the error (for example, show an alert to the user)
            print("Error: \(error.localizedDescription)")
        }

        coursesViewModel.fetchCourses()
    }

    // MARK: - UI Setup
    private func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: courseCellIdentifier)
        view.addSubview(tableView)
    }

    // MARK: - Course Deletion
    func confirmDeleteCourse(at index: Int) {
        let alert = UIAlertController(title: "Ders Silme", message: "Bu dersi silmek istediğinizden emin misiniz?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            self?.coursesViewModel.deleteCourse(at: index) { error in
                if let error = error {
                    print("Error deleting course: \(error.localizedDescription)")
                    return
                }
                self?.coursesViewModel.fetchCourses()
            }
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

extension CoursesListViewController: CoursesDelegateCallback {

    func didSelectCourse(course: Course) {
        let detailVC = DetailViewController()
        detailVC.setupCourseInfo(course: course)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func didDeleteCourse(at index: Int) {
        confirmDeleteCourse(at: index)
    }
}
