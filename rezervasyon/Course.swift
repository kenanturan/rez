//
//  Course.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 23.10.2023.
//

import Foundation
import Firebase
import FirebaseCore

// Önce Course yapısalını tanımlayın
struct Course {
    var id: String
    var courseName: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var currentAttendees: Int
    var capacity: Int

}

// Ardından Course yapısalını genişletin
extension Course {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        let id = document.documentID
        let courseName = data["courseName"] as? String ?? ""
        let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
        let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
        let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
        let currentAttendees = data["currentAttendees"] as? Int ?? 0
        let capacity = data["capacity"] as? Int ?? 0

        
        // Course yapısalının özelliklerini kullanarak bu yapısalı başlatın:
        self.id = id
        self.courseName = courseName
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.currentAttendees = currentAttendees
        self.capacity = capacity
    }
}
