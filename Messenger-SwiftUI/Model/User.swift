//
//  User.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation

struct User: Codable, Identifiable, Hashable{
    var id = NSUUID().uuidString
    let fullname: String
    let email: String
    let profileImageUrl: String?
}

extension User{
    static var MOCK_USER = User(fullname: "Nga", email: "expensive@gmail.com", profileImageUrl: "ps-4")
}
