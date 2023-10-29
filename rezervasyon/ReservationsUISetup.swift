//
//  ReservationsUISetup.swift
//  rezervasyon
//
//  Created by Kenan TURAN on 29.10.2023.
//

import Foundation
import UIKit

class ReservationsUISetup {
    
    // TableView oluşturma
    func createTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "reservationCell")
        return table
    }
    
    // Diğer UI bileşenlerini oluşturma metotları burada tanımlanabilir.
    // Örneğin bir activity indicator, hata mesajı label'i vb. için.
    // ...
}
