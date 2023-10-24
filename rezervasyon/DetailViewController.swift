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
    
    private let reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rezervasyon Yap", for: .normal)
        button.addTarget(self, action: #selector(handleReserve), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white  // Beyaz arkaplan rengi
        
        let stackView = UIStackView(arrangedSubviews: [courseNameLabel, courseDateLabel, startTimeLabel, endTimeLabel, capacityLabel, reserveButton])
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
    }
    
    @objc private func handleReserve() {
        guard var currentCourse = course else { return }
        
        if currentCourse.capacity > 0 {
            currentCourse.capacity -= 1
            capacityLabel.text = "Kapasite: \(currentCourse.capacity)"
            
            // Firebase'e yeni kapasite değerini kaydedin
            saveUpdatedCapacity(for: currentCourse)
        } else {
            // Kapasite 0 ise kullanıcıyı bilgilendirin
            let alert = UIAlertController(title: "Uyarı", message: "Bu ders için yer kalmamıştır.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func saveUpdatedCapacity(for course: Course) {
        let db = Firestore.firestore()
        db.collection("courses").document(course.id).updateData(["capacity": course.capacity]) { error in
            if let error = error {
                print("Failed to update capacity: \(error.localizedDescription)")
                return
            }
            print("Capacity updated successfully!")
        }
    }
}
