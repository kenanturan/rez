import Foundation
import Firebase
import FirebaseCore

class DetailViewController: UIViewController {
    
    var course: Course? // Bu property, seçilen dersin bilgilerini tutar
    
    private let courseNameLabel = UILabel()
    private let courseDateLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let endTimeLabel = UILabel()
    private let capacityLabel = UILabel()
    private var didReserve: Bool = false
    private let reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rezervasyon Yap", for: .normal)
        return button
    }()

    private let cancelReservationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rezervasyon Sil", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white  // Beyaz arkaplan rengi
        
        let stackView = UIStackView(arrangedSubviews: [courseNameLabel, courseDateLabel, startTimeLabel, endTimeLabel, capacityLabel, reserveButton, cancelReservationButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        
        // stackView konumlandırması
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        reserveButton.addTarget(self, action: #selector(handleReserveButtonTap), for: .touchUpInside)
        cancelReservationButton.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)
        
        updateUIBasedOnReservationStatus()
    }
    private func updateUIBasedOnReservationStatus() {
        if let currentUserID = Auth.auth().currentUser?.uid, let course = course {
            didReserve = course.reservedUserIDs.contains(currentUserID)
            
            reserveButton.isHidden = didReserve
            cancelReservationButton.isHidden = !didReserve
        }
    }

    func setupCourseInfo(course: Course) {
        self.course = course
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        // Ders Adı
        courseNameLabel.text = "Ders Adı: \(course.courseName)"
        
        // Ders Tarihi
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: course.date)
        courseDateLabel.text = "Ders Tarihi: \(formattedDate)"
        
        // Başlama ve Bitiş Saati
        dateFormatter.dateFormat = "HH:mm"
        let formattedStartTime = dateFormatter.string(from: course.startTime)
        let formattedEndTime = dateFormatter.string(from: course.endTime)
        startTimeLabel.text = "Başlama Saati: \(formattedStartTime)"
        endTimeLabel.text = "Bitiş Saati: \(formattedEndTime)"
        
        // Kapasite
        capacityLabel.text = "Kapasite: \(course.capacity)"
        if course.capacity < course.capacity {
            didReserve = true
        } else {
            didReserve = false
        }
    }
    
    private func handleReservation(actionType: ReservationAction) {
        guard var currentCourse = course, let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        switch actionType {
        case .reserve:
            if currentCourse.capacity > 0 && !currentCourse.reservedUserIDs.contains(currentUserID) {
                currentCourse.capacity -= 1
                currentCourse.reservedUserIDs.append(currentUserID) // Kullanıcıyı ekleyin
                capacityLabel.text = "Kapasite: \(currentCourse.capacity)"
                
                // Firebase'e yeni kapasite değerini ve reservedUserIDs'yi kaydedin
                saveUpdatedCapacity(for: currentCourse)
            } else {
                // Kapasite 0 ise ya da kullanıcı zaten rezervasyon yapmışsa bilgilendirin
                let alert = UIAlertController(title: "Uyarı", message: "Bu ders için yer kalmamıştır ya da zaten rezervasyon yapmışsınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                present(alert, animated: true)
            }

        case .cancel:
            if currentCourse.reservedUserIDs.contains(currentUserID) {
                currentCourse.capacity += 1
                if let index = currentCourse.reservedUserIDs.firstIndex(of: currentUserID) {
                    currentCourse.reservedUserIDs.remove(at: index) // Kullanıcıyı kaldırın
                }
                capacityLabel.text = "Kapasite: \(currentCourse.capacity)"
                // Firebase'e yeni kapasite değerini ve reservedUserIDs'yi kaydedin
                saveUpdatedCapacity(for: currentCourse)
            } else {
                // Kullanıcı bu ders için rezervasyon yapmamış
                let alert = UIAlertController(title: "Uyarı", message: "Bu ders için rezervasyon yapmamışsınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                present(alert, animated: true)
            }

        }
    }


    enum ReservationAction {
        case reserve
        case cancel
    }
    
    @objc private func handleReserveButtonTap() {
        if let currentUserID = Auth.auth().currentUser?.uid {
            if !course!.reservedUserIDs.contains(currentUserID) {
                handleReservation(actionType: .reserve)
                didReserve = true
            } else {
                // Kullanıcı zaten rezervasyon yapmış
                let alert = UIAlertController(title: "Uyarı", message: "Zaten bu ders için rezervasyon yapmışsınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                present(alert, animated: true)
            }
        }
    }

    @objc private func handleCancelButtonTap() {
        if let currentUserID = Auth.auth().currentUser?.uid {
            if course!.reservedUserIDs.contains(currentUserID) {
                handleReservation(actionType: .cancel)
                didReserve = false
            } else {
                // Kullanıcı bu ders için rezervasyon yapmamış
                let alert = UIAlertController(title: "Uyarı", message: "Bu ders için rezervasyon yapmamışsınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                present(alert, animated: true)
            }
        }
    }



    
    private func saveUpdatedCapacity(for course: Course) {
        let db = Firestore.firestore()
        db.collection("courses").document(course.id).updateData([
            "capacity": course.capacity,
            "reservedUserIDs": course.reservedUserIDs
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to update data: \(error.localizedDescription)")
                self.showAlert(title: "Hata", message: "Bir hata oluştu. Lütfen tekrar deneyin.")
                return
            }
            
            print("Capacity and reservedUserIDs updated successfully!")
            
            // Burada didReserve değerini ve UI'ı güncelleyin
            self.updateUIBasedOnReservationStatus()
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
