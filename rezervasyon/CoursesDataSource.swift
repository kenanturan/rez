//
//  CoursesDataSource.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class CoursesDataSource: NSObject, UITableViewDataSource {

    var courses: [Course] = []

    private let courseCellIdentifier = "courseCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseCellIdentifier, for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.courseName
        cell.detailTextLabel?.text = "Kapasite: \(course.capacity)"
        return cell
    }

}
