import Foundation
import UIKit
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()

    private init() {}

    func redirectToLogin(from viewController: UIViewController) {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true, completion: nil)
    }

    @objc func logoutTapped(from controller: UIViewController) {
        do {
            try Auth.auth().signOut()
            redirectToLogin(from: controller)
        } catch let signOutError as NSError {
            print("Oturumu kapatma hatası: %@", signOutError)
        }
    }
    
    @objc func goToAddCourse(from viewController: UIViewController) {
        let addCourseVC = AddCourseViewController()
        viewController.navigationController?.pushViewController(addCourseVC, animated: true)
    }
}
