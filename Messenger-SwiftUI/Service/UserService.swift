//
//  UserService.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService{
    
    @Published var currentUser: User?
    
    static var shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
}
