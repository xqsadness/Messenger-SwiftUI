//
//  User.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable{
    @DocumentID var uid: String?
    let fullname: String
    let email: String
    let profileImageUrl: String?
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
}

extension User{
    static var MOCK_USER = User(fullname: "Nga", email: "expensive@gmail.com", profileImageUrl: "ps-4")
}
