//
//  FirebaseAuthManager.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseAuthManager {
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result))
            }
        }
    }
}
