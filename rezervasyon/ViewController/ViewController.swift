//
//  2.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 2.11.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {
    var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // UIManager'dan logoImageView alın ve ana görünüme ekleyin
        logoImageView = UIManager.shared.setupLogoImageView()
        view.addSubview(logoImageView)
        
        // Logo için kısıtlamaları ayarlayın
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])

        
        UserService.shared.fetchCurrentUser { (user) in
            print("Firebase'dan gelen rol: \(user?.role.rawValue ?? "Bilinmiyor")")
            DispatchQueue.main.async {
                if let userRole = user?.role, userRole == .admin {
                    self.setupAdminUI()
                } else {
                    self.setupDefaultUI()
                }
            }
        }
        setupLogoutButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser == nil {
            // Kullanıcı oturumu kapalı, giriş ekranına yönlendir
            redirectToLogin()
        }
    }
    
    func setupLogoutButton() {
        UIManager.shared.setupLogoutButton()
    }

    func clearButtons() {
        UIManager.shared.clearButtons()
    }
    func setupAdminUI() {
        UIManager.shared.setupAdminUI()
    }

    func setupDefaultUI() {
        UIManager.shared.setupDefaultUI()
    }
    
    func redirectToLogin() {
        AuthManager.shared.redirectToLogin(from: self)
    }
    @objc func logoutButtonTapped() {
        AuthManager.shared.logoutTapped(from: self)
    }

    @objc func goToAddCourse() {
        AuthManager.shared.goToAddCourse(from: self)
    }

    @objc func goToCoursesList() {
        let coursesListVC = CoursesListViewController()
        self.navigationController?.pushViewController(coursesListVC, animated: true)
    }

    @objc func goToReservations() {
        let reservationsVC = ReservationsViewController()
        self.navigationController?.pushViewController(reservationsVC, animated: true)
    }


    @objc func viewReservedUsers() {
        let reservationUsersVC = ReservationUsersViewController()
        self.navigationController?.pushViewController(reservationUsersVC, animated: true)
    }

    @objc func goToAddUser() {
        NavigationManager.shared.goToAddUser(from: self)
    }
}
