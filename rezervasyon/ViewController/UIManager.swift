//
//  UIManager.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 1.11.2023.
//

//setupLogoutButton()
//clearButtons()
//setupAdminUI()
//setupDefaultUI()


import Foundation
import UIKit

class UIManager: UIViewController {

    static let shared = UIManager()

    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.setTitle(NSLocalizedString("logoutButtonTitle", comment: "Çıkış yap butonu metni"), for: .normal)
        logoutButton.backgroundColor = .darkGray
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(AuthManager.shared.logoutTapped(from:)), for: .touchUpInside)

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
    addButton.addTarget(AuthManager.shared, action: #selector(AuthManager.shared.goToAddCourse), for: .touchUpInside)
    view.addSubview(addButton)

    let userAddButton = UIButton()
    userAddButton.setTitle(NSLocalizedString("addUserButtonTitle", comment: ""), for: .normal)
    userAddButton.backgroundColor = .red
    userAddButton.translatesAutoresizingMaskIntoConstraints = false

    // ViewController instance'ını kullanarak selector ayarlayın
    let viewControllerInstance = ViewController()
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
