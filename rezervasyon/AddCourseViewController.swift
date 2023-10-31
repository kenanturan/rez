//
//  AddCourseViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 23.10.2023.
//

import UIKit
import FirebaseFirestore

class AddCourseViewController: UIViewController {
    // UI Components
    private var db = Firestore.firestore()

    private let courseNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("courseNamePlaceholder", comment: "")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let courseCapacityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("courseCapacityPlaceholder", comment: "")
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("addButtonTitle", comment: ""), for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // Zemin rengini beyaz yap
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(courseNameTextField)
        view.addSubview(datePicker)
        view.addSubview(startTimePicker)
        view.addSubview(endTimePicker)
        view.addSubview(courseCapacityTextField)
        view.addSubview(addButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            courseNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            courseNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            courseNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: courseNameTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startTimePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            startTimePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            endTimePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            endTimePicker.leadingAnchor.constraint(equalTo: startTimePicker.trailingAnchor, constant: 20),
            endTimePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endTimePicker.widthAnchor.constraint(equalTo: startTimePicker.widthAnchor),
            
            courseCapacityTextField.topAnchor.constraint(equalTo: endTimePicker.bottomAnchor, constant: 20),
            courseCapacityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            courseCapacityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: courseCapacityTextField.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func addButtonTapped() {
        guard let courseName = courseNameTextField.text, !courseName.isEmpty else {
            print(NSLocalizedString("courseNameEmptyError", comment: ""))
            return
        }

        let courseDate = datePicker.date
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date

        guard let courseCapacity = Int(courseCapacityTextField.text ?? "0"), courseCapacity > 0 else {
            print(NSLocalizedString("validCourseCapacityError", comment: ""))
            return
        }

        addCourse(courseName: courseName, courseDate: courseDate, startTime: startTime, endTime: endTime, capacity: courseCapacity)
    }

    private func addCourse(courseName: String, courseDate: Date, startTime: Date, endTime: Date, capacity: Int) {
        let courseData: [String: Any] = [
            "courseName": courseName,
            "courseDate": courseDate,
            "startTime": startTime,
            "endTime": endTime,
            "capacity": capacity
        ]

        db.collection("courses").addDocument(data: courseData) { [weak self] error in
            if let error = error {
                let errorMessage = NSLocalizedString("courseAdditionError", comment: "") + error.localizedDescription
                print(errorMessage)
                self?.showAlert(title: NSLocalizedString("errorTitle", comment: ""), message: errorMessage)
            } else {
                print(NSLocalizedString("courseAddedSuccess", comment: ""))
                self?.showAlert(title: NSLocalizedString("successTitle", comment: ""), message: NSLocalizedString("courseAddedSuccess", comment: ""))
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("okActionTitle", comment: ""), style: .default))
        self.present(alert, animated: true)
    }
}
