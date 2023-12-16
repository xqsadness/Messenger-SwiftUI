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
    
    @MainActor
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User]{
        let query = FirestoreContants.userCollection
        if let limit { query.limit(to: limit) }
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        FirestoreContants.userCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
