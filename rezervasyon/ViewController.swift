//
//  ViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 23.10.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        fetchUser { (user) in
            print("Firebase'dan gelen rol: \(user?.role.rawValue ?? "Bilinmiyor")")
            DispatchQueue.main.async {
                if let userRole = user?.role, userRole == .admin {
                    self.setupAdminUI()
                } else {
                    self.setupDefaultUI()
                }
            }
        }
    }
        
        
        func setupAdminUI() {
            // Admin için "Ders Ekle" butonu
            let addButton = UIButton(frame: CGRect(x: (view.frame.width - 200) / 2, y: (view.frame.height - 120) / 2, width: 200, height: 50))
            addButton.setTitle("Ders Ekle", for: .normal)
            addButton.backgroundColor = .blue
            addButton.addTarget(self, action: #selector(goToAddCourse), for: .touchUpInside)
            view.addSubview(addButton)
            
            // Her kullanıcı için "Dersleri Listele" butonu
            setupDefaultUI()
        }
        
        @objc func goToAddCourse() {
            let addCourseVC = AddCourseViewController()
            self.navigationController?.pushViewController(addCourseVC, animated: true)
        }
        
        @objc func goToCoursesList() {
            let coursesListVC = CoursesListViewController()
            self.navigationController?.pushViewController(coursesListVC, animated: true)
        }
        
        func fetchUser(completion: @escaping (User?) -> Void) {
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
    func setupDefaultUI() {
        // Dersleri Listele butonu
        let listButton = UIButton(frame: CGRect(x: (view.frame.width - 200) / 2, y: (view.frame.height) / 2 + 10, width: 200, height: 50))
        listButton.setTitle("Dersleri Listele", for: .normal)
        listButton.backgroundColor = .green
        listButton.addTarget(self, action: #selector(goToCoursesList), for: .touchUpInside)
        view.addSubview(listButton)

        // Kullanıcı Ekle butonu
        let userAddButton = UIButton(frame: CGRect(x: (view.frame.width - 200) / 2, y: listButton.frame.maxY + 20, width: 200, height: 50))
        userAddButton.setTitle("Kullanıcı Ekle", for: .normal)
        userAddButton.backgroundColor = .orange
        userAddButton.addTarget(self, action: #selector(goToAddUser), for: .touchUpInside)
        view.addSubview(userAddButton)
        let usersListButton = UIButton(frame: CGRect(x: (view.frame.width - 200) / 2, y: listButton.frame.maxY + 80, width: 200, height: 50))
        usersListButton.setTitle("Kullanıcıları Listele", for: .normal)
        usersListButton.backgroundColor = .purple
        usersListButton.addTarget(self, action: #selector(showUsersList), for: .touchUpInside)
        view.addSubview(usersListButton)
    }

    @objc func goToAddUser() {
        let alertController = UIAlertController(title: "Kullanıcı Ekle", message: "E-posta ve şifre girin", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "E-posta"
        }
        
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Şifre"
        }
        
        let addAction = UIAlertAction(title: "Ekle", style: .default) { (_) in
            guard let emailField = alertController.textFields?[0], let passwordField = alertController.textFields?[1] else {
                return
            }

            if let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print("Kullanıcı eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Kullanıcı başarıyla eklendi.")
                    }
                }
            } else {
                print("E-posta veya şifre eksik.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func showUsersList() {
        let usersListVC = UsersListViewController()
        self.navigationController?.pushViewController(usersListVC, animated: true)
    }

}
