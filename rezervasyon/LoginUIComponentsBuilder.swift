//
//  LoginUIComponentsBuilder.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class LoginUIComponentsBuilder {
    
    static func createEmailTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.borderStyle = .roundedRect
        return textField
    }
    
    static func createPasswordTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }
    
    static func createLoginButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
