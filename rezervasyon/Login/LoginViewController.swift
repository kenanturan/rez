//  LoginViewController.swift
//  Pods
//
//  Created by Kenan TURAN on 23.10.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        setupLocalizedStrings()
    }
    
    private func setupLocalizedStrings() {
        loginView.emailTextField.placeholder = Localization.localizedString(forKey: "email_placeholder")
        loginView.passwordTextField.placeholder = Localization.localizedString(forKey: "password_placeholder")
        loginView.loginButton.setTitle(Localization.localizedString(forKey: "login_button_title"), for: .normal)
    }

    @objc private func handleLogin() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Hata", message: Localization.localizedString(forKey: "empty_fields_error"))
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error as NSError? {
                var errorMessage = Localization.localizedString(forKey: "login_error")
                let errorCode = AuthErrorCode.Code(rawValue: error.code)
                switch errorCode {
                case .internalError:
                    errorMessage = Localization.localizedString(forKey: "internal_error")
                default:
                    errorMessage += " \(error.localizedDescription)"
                }
                
                self?.showAlert(title: Localization.localizedString(forKey: "login_error_title"), message: errorMessage)
                return
            }

            // Giriş başarılı
            let mainVC = ViewController() // ViewController'ın adını güncelleyin.
            let navigationController = UINavigationController(rootViewController: mainVC)
            navigationController.modalPresentationStyle = .fullScreen // Tam ekran sunum için
            self?.present(navigationController, animated: true)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localization.localizedString(forKey: "ok"), style: .default))
        present(alert, animated: true)
    }
}
