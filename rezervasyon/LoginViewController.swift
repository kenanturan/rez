//
//  LoginViewController.swift
//  Pods
//
//  Created by Kenan TURAN on 23.10.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Kimura.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLocalizedStrings()
        setupLayout()
    }
    
    private func setupLocalizedStrings() {
        emailTextField.placeholder = NSLocalizedString("email_placeholder", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password_placeholder", comment: "")
        loginButton.setTitle(NSLocalizedString("login_button_title", comment: ""), for: .normal)
    }

    private func setupLayout() {
        // Logo ImageView Setup
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])

        // StackView Setup
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }

    @objc private func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Hata", message: NSLocalizedString("empty_fields_error", comment: ""))
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error as NSError? {
                var errorMessage = NSLocalizedString("login_error", comment: "")
                let errorCode = AuthErrorCode.Code(rawValue: error.code)
                switch errorCode {
//                case .userNotFound:
//                    errorMessage = "Kullanıcı bulunamadı. Lütfen kayıt olun."
//                case .wrongPassword:
//                    errorMessage = "Hatalı şifre. Lütfen tekrar deneyin."
//                case .userDisabled:
//                    errorMessage = "Bu kullanıcı hesabı engellenmiştir."
                case .internalError:
                    errorMessage = NSLocalizedString("internal_error", comment: "")
                default:
                    errorMessage += " \(error.localizedDescription)"
                }
                
                self?.showAlert(title: NSLocalizedString("login_error_title", comment: ""), message: errorMessage)
                return
            }

            // Giriş başarılı
            let mainVC = ViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            navigationController.modalPresentationStyle = .fullScreen // Tam ekran sunum için
            self?.present(navigationController, animated: true)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        present(alert, animated: true)
    }
}
