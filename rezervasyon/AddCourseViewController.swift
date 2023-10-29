//
//  AddCourseViewController.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class AddCourseViewController: UIViewController {
    
    // UI Components
    private let courseNameTextField = CourseUIComponentsBuilder.createCourseNameTextField()
    private let datePicker = CourseUIComponentsBuilder.createDatePicker(mode: .date)
    private let startTimePicker = CourseUIComponentsBuilder.createDatePicker(mode: .time)
    private let endTimePicker = CourseUIComponentsBuilder.createDatePicker(mode: .time)
    private let courseCapacityTextField = CourseUIComponentsBuilder.createCourseCapacityTextField()
    private lazy var addButton = CourseUIComponentsBuilder.createAddButton(target: self, action: #selector(addButtonTapped))
    
    private var firestoreCourseManager = FirestoreCourseManager()

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
        // (Bu kısım aynı şekilde kalabilir.)
    }
    
    @objc private func addButtonTapped() {
        guard let courseName = courseNameTextField.text, !courseName.isEmpty else {
            print("Lütfen ders adını girin.")
            return
        }

        let courseDate = datePicker.date
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date

        guard let courseCapacity = Int(courseCapacityTextField.text ?? "0"), courseCapacity > 0 else {
            print("Lütfen geçerli bir ders kapasitesi girin.")
            return
        }

        let courseData: [String: Any] = [
            "courseName": courseName,
            "courseDate": courseDate,
            "startTime": startTime,
            "endTime": endTime,
            "capacity": courseCapacity
        ]

        firestoreCourseManager.addCourse(courseData: courseData) { error in
            if let error = error {
                print("Ders eklenirken hata: \(error)")
            } else {
                print("Ders başarıyla eklendi!")
            }
        }
    }
}
