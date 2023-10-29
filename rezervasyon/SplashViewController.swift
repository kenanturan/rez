//
//  SplashViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit
import FirebaseAuth


class SplashViewController: UIViewController {
    private var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "Kimura.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)

        // 3 saniye sonra ana ekranı göster
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMainScreen()
        }
    }

    func navigateToMainScreen() {
        // Kullanıcının oturum açıp açmadığını kontrol edin
        if Auth.auth().currentUser == nil {
            // Kullanıcı oturumu kapalı, giriş ekranına yönlendir
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        } else {
            // Kullanıcı oturumu açık, ana ekrana yönlendir
            let mainViewController = ViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
