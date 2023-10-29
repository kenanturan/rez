//
//  CoursesDataFetcher.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

class CoursesDataFetcher {
    func fetchCourses(completion: @escaping ([Course]) -> Void) {
        let db = Firestore.firestore()
        db.collection("courses").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching courses: \(error.localizedDescription)")
                completion([])
                return
            }
            
            let courses = querySnapshot?.documents.compactMap { document in
                return Course(document: document)
            } ?? []
            
            completion(courses)
        }
    }
}
