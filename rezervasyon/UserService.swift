//
//  UserService.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 31.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    static let shared = UserService()

    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(currentUserUID).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let roleString = data["role"] as? String ?? "user"
                let role = UserRole(rawValue: roleString) ?? .user

                let user = User(uid: uid, email: email, role: role)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
