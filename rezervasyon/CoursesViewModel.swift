//
//  CoursesViewModel.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class CoursesViewModel {

    // Properties
    var courses: [Course] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    // Firestore reference
    private var db: Firestore {
        return Firestore.firestore()
    }

    // Fetch courses from Firestore
    func fetchCourses() {
        db.collection("courses").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                self?.onError?(error)
                return
            }

            self?.courses = querySnapshot?.documents.compactMap { document in
                return Course(document: document)
            } ?? []

            // Notify the ViewController about the data update
            self?.onDataUpdated?()
        }
    }

    // Delete a course from Firestore
    func deleteCourse(at index: Int, completion: @escaping (Error?) -> Void) {
        let courseID = courses[index].id

        db.collection("courses").document(courseID).delete() { error in
            if let error = error {
                completion(error)
                return
            }

            self.courses.remove(at: index)
            completion(nil)
        }
    }
}
