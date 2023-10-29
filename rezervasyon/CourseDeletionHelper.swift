//
//  CourseDeletionHelper.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

class CourseDeletionHelper {
    func deleteCourse(courseID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("courses").document(courseID).delete() { error in
            if let error = error {
                print("Error deleting course: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
