//
//  UserModel.swift
//  Pods
//
//  Created by Kenan TURAN on 23.10.2023.
//

import Foundation

struct User {
    let uid: String
    let email: String
    var role: UserRole
}

enum UserRole: String {
    case admin
    case user
}

