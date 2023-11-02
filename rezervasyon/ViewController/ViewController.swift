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
        // Logo için UIImageView oluştur
        logoImageView = UIImageView(image: UIImage(named: "Kimura.png"))
        logoImageView.contentMode = .scaleAspectFit // Görüntüyü ölçeklendir
        logoImageView.translatesAutoresizingMaskIntoConstraints = false // Otomatik oluşturulan kısıtlamaları devre dışı bırak
        view.addSubview(logoImageView) // Görüntüyü ana görünüme ekleyin
        
        // Logo için kısıtlamaları ayarlayın (Örneğin: Ekranın üstünden 20 birim boşluk bırakarak ve genişliği ekranın %80'i olacak şekilde ayarlayın)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), // Ekran genişliğinin %50'si
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)  // Kare şeklinde bir logo varsayılarak ayarlandı.
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
        let logoutButton = UIButton()
        logoutButton.setTitle(NSLocalizedString("logoutButtonTitle", comment: "Çıkış yap butonu metni"), for: .normal)
        logoutButton.backgroundColor = .darkGray
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(AuthManager.logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func clearButtons() {
        view.subviews.forEach({ if $0 is UIButton { $0.removeFromSuperview() } })
    }
    func setupAdminUI() {
        clearButtons() // Önceki butonları kaldır
        // Önceki butonları kaldırıp tekrar ekleyerek çakışmaların önüne geçelim.
        view.subviews.forEach({ if $0 is UIButton { $0.removeFromSuperview() } })
        
        let addButton = UIButton()
        addButton.setTitle(NSLocalizedString("addCourseButtonTitle", comment: ""), for: .normal)
        addButton.backgroundColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(goToAddCourse), for: .touchUpInside)
        view.addSubview(addButton)

        let userAddButton = UIButton()
        userAddButton.setTitle(NSLocalizedString("addUserButtonTitle", comment: ""), for: .normal)
        userAddButton.backgroundColor = .red
        userAddButton.translatesAutoresizingMaskIntoConstraints = false
        userAddButton.addTarget(self, action: #selector(goToAddUser), for: .touchUpInside)
        view.addSubview(userAddButton)

        let viewReservedUsersButton = UIButton()
        viewReservedUsersButton.setTitle(NSLocalizedString("viewReservedUsersButtonTitle", comment: ""), for: .normal)
        viewReservedUsersButton.backgroundColor = .black
        viewReservedUsersButton.translatesAutoresizingMaskIntoConstraints = false
        viewReservedUsersButton.addTarget(self, action: #selector(viewReservedUsers), for: .touchUpInside)
        view.addSubview(viewReservedUsersButton)
        
        let listButton = UIButton()
        listButton.setTitle(NSLocalizedString("listCoursesButtonTitle", comment: ""), for: .normal)
        listButton.backgroundColor = .red
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.addTarget(self, action: #selector(goToCoursesList), for: .touchUpInside)
        view.addSubview(listButton)

        let reservationsButton = UIButton()
        reservationsButton.setTitle(NSLocalizedString("myReservationsButtonTitle", comment: ""), for: .normal)
        reservationsButton.backgroundColor = .black
        reservationsButton.translatesAutoresizingMaskIntoConstraints = false
        reservationsButton.addTarget(self, action: #selector(goToReservations), for: .touchUpInside)
        view.addSubview(reservationsButton)

        // Kısıtlamaları ayarlayalım
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50),

            userAddButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            userAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAddButton.widthAnchor.constraint(equalToConstant: 200),
            userAddButton.heightAnchor.constraint(equalToConstant: 50),

            viewReservedUsersButton.topAnchor.constraint(equalTo: userAddButton.bottomAnchor, constant: 10),
            viewReservedUsersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewReservedUsersButton.widthAnchor.constraint(equalToConstant: 200),
            viewReservedUsersButton.heightAnchor.constraint(equalToConstant: 50),
            
            listButton.topAnchor.constraint(equalTo: viewReservedUsersButton.bottomAnchor, constant: 10),
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listButton.widthAnchor.constraint(equalToConstant: 200),
            listButton.heightAnchor.constraint(equalToConstant: 50),

            reservationsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reservationsButton.topAnchor.constraint(equalTo: listButton.bottomAnchor, constant: 10),
            reservationsButton.widthAnchor.constraint(equalToConstant: 200),
            reservationsButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        setupLogoutButton() // Her iki UI'da da ortak olan "Çıkış Yap" butonunu ekleyin
    }
    
    func setupDefaultUI() {
        clearButtons() // Önceki butonları kaldır
        let listButton = UIButton()
        listButton.setTitle(NSLocalizedString("listCoursesButtonTitle", comment: ""), for: .normal)
        listButton.backgroundColor = .black
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.addTarget(self, action: #selector(goToCoursesList), for: .touchUpInside)
        view.addSubview(listButton)

        let reservationsButton = UIButton()
        reservationsButton.setTitle(NSLocalizedString("myReservationsButtonTitle", comment: ""), for: .normal)
        reservationsButton.backgroundColor = .red
        reservationsButton.translatesAutoresizingMaskIntoConstraints = false
        reservationsButton.addTarget(self, action: #selector(goToReservations), for: .touchUpInside)
        view.addSubview(reservationsButton)

        NSLayoutConstraint.activate([
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            listButton.widthAnchor.constraint(equalToConstant: 200),
            listButton.heightAnchor.constraint(equalToConstant: 50),

            reservationsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reservationsButton.topAnchor.constraint(equalTo: listButton.bottomAnchor, constant: 20),
            reservationsButton.widthAnchor.constraint(equalToConstant: 200),
            reservationsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        setupLogoutButton() // Her iki UI'da da ortak olan "Çıkış Yap" butonunu ekleyin
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

        self.present(alertController, animated: true, completion: nil)
    }
}
