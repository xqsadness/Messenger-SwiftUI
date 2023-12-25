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
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        if snapshot.exists{
            let user = try snapshot.data(as: User.self)
            self.currentUser = user
        }else{
            AuthService.shared.signOut()
        }
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
    
    static func fetchUserAsync(withUid uid: String) async throws -> User {
        let document = FirestoreContants.userCollection.document(uid)
        let snapshot = try await document.getDocument()
        let user = try snapshot.data(as: User.self)
        
        return user
    }
}
