//
//  ReservedUsersDataFetcher.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class ReservedUsersDataFetcher {
    
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    // Kullanıcıların e-posta adreslerini almak için bir işlev.
    func fetchUserEmails(forUserIDs userIDs: [String], completion: @escaping ([String]) -> Void) {
        var userEmails: [String] = []
        let group = DispatchGroup()
        
        for userID in userIDs {
            group.enter()
            db.collection("users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists, let data = document.data() {
                    let email = data["email"] as? String ?? ""
                    userEmails.append(email)
                } else {
                    userEmails.append("E-posta bulunamadı")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(userEmails)
        }
    }
}
