//
//  CoursesDelegate.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

protocol CoursesDelegateCallback: AnyObject {
    func didSelectCourse(course: Course)
    func didDeleteCourse(at index: Int)
}
class CoursesDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: CoursesDelegateCallback?
    var courses: [Course] = []

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCourse = courses[indexPath.row]
        delegate?.didSelectCourse(course: selectedCourse)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didDeleteCourse(at: indexPath.row)
        }
    }
}
