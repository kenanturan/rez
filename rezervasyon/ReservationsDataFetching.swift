//
//  ReservationsDataFetching.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import Firebase

class ReservationsDataFetching {

    private var db: Firestore {
        return Firestore.firestore()
    }

    // Kullanıcının yapmış olduğu rezervasyonları getiren bir işlev.
    func fetchUserReservations(completion: @escaping ([Course]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("courses").whereField("reservedUserIDs", arrayContains: currentUserID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Rezervasyonları getirirken hata oluştu: \(error.localizedDescription)")
                completion([])
                return
            }

            var userReservations: [Course] = []

            for document in querySnapshot?.documents ?? [] {
                if let course = Course(document: document) {
                    userReservations.append(course)
                }
            }

            completion(userReservations)
        }
    }
}
