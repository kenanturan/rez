//
//  NavigationManager.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 1.11.2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class NavigationManager {
    
    static let shared = NavigationManager()

    private init() {}


    func goToAddUser(from viewController: UIViewController) {
        let alertController = UIAlertController(
            title: NSLocalizedString("addUserAlertTitle", comment: ""),
            message: NSLocalizedString("addUserAlertMessage", comment: ""),
            preferredStyle: .alert
        )
        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("emailPlaceholder", comment: "")
        }

        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
        }

        let addAction = UIAlertAction(
            title: NSLocalizedString("addActionTitle", comment: ""),
            style: .default
        ) { (_) in
            guard let emailField = alertController.textFields?[0], let passwordField = alertController.textFields?[1] else {
                return
            }

            if let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print("Kullanıcı eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Kullanıcı başarıyla eklendi.")

                        // Buraya Firestore'a kullanıcı bilgisi eklemek için kodları ekleyin
                        if let user = authResult?.user {
                            let db = Firestore.firestore()
                            db.collection("users").document(user.uid).setData([
                                "uid": user.uid,
                                "email": user.email ?? "",
                                "role": "user"  // varsayılan olarak "user" rolü
                            ]) { (error) in
                                if let error = error {
                                    print("Firestore'a kullanıcı eklenirken hata: \(error.localizedDescription)")
                                } else {
                                    print("Firestore'a kullanıcı başarıyla eklendi.")
                                }
                            }
                        }
                    }
                }
            } else {
                print("E-posta veya şifre eksik.")
            }
        }

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancelActionTitle", comment: ""),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }


    func goToCoursesList(from viewController: UIViewController) {
        let coursesListVC = CoursesListViewController()
        viewController.navigationController?.pushViewController(coursesListVC, animated: true)
    }

    func goToReservations(from viewController: UIViewController) {
        let reservationsVC = ReservationsViewController()
        viewController.navigationController?.pushViewController(reservationsVC, animated: true)
    }


    func viewReservedUsers(from viewController: UIViewController) {
        let reservationUsersVC = ReservationUsersViewController()
        viewController.navigationController?.pushViewController(reservationUsersVC, animated: true)
    }
}
