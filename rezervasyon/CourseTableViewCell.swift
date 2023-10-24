//
//  CourseTableViewCell.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 23.10.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class CourseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

