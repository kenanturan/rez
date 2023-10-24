//
//  LoginViewController.swift
//  Pods
//
//  Created by Kenan TURAN on 23.10.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

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

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Giriş yapılırken hata oluştu: \(error)")
                return
            }

            // Giriş başarılı
            let mainVC = ViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            navigationController.modalPresentationStyle = .fullScreen // Tam ekran sunum için
            self?.present(navigationController, animated: true)
        }
    }
}
