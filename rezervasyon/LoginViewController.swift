//
//  LoginViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    private let emailTextField = LoginUIComponentsBuilder.createEmailTextField()
    private let passwordTextField = LoginUIComponentsBuilder.createPasswordTextField()
    private lazy var loginButton = LoginUIComponentsBuilder.createLoginButton(target: self, action: #selector(handleLogin))
    
    private let authManager = FirebaseAuthManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }

    @objc private func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun.")
            return
        }

        authManager.signIn(withEmail: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                let mainVC = ViewController()
                let navigationController = UINavigationController(rootViewController: mainVC)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
                
            case .failure(let error):
                print("Giriş yapılırken hata oluştu: \(error)")
            }
        }
    }
}
