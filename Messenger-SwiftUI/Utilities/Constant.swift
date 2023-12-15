//
//  Constant.swift
//  Messenger-SwiftUI
//
//  Created by darktech4 on 15/12/2023.
//

import Foundation
import Firebase

struct FirestoreContants{
    static let userCollection = Firestore.firestore().collection("users")
    static let messageCollection = Firestore.firestore().collection("messages")
}
