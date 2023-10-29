//
//  CourseUIComponentsBuilder.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class CourseUIComponentsBuilder {
    
    static func createCourseNameTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Ders Adı"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func createDatePicker(mode: UIDatePicker.Mode) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }
    
    static func createCourseCapacityTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Ders Kapasitesi"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func createAddButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle("Ekle", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
