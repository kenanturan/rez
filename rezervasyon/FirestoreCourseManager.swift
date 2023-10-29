//
//  FirestoreCourseManager.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import FirebaseFirestore

class FirestoreCourseManager {
    
    private var db = Firestore.firestore()
    
    func addCourse(courseData: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("courses").addDocument(data: courseData) { error in
            completion(error)
        }
    }
}
