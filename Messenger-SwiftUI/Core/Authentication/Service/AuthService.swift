//
//  AuthService.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static var shared = AuthService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            LocalNotification.shared.message("\(error.localizedDescription)", .warning)
            debugPrint("ERROR: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
            loadCurrentUserData()
        } catch {
            LocalNotification.shared.message("\(error.localizedDescription)", .warning)
            debugPrint("ERROR: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    
    func resetPassword(email: String) async throws{
        do{
            try await Auth.auth().sendPasswordReset(withEmail: email)
            LocalNotification.shared.message("We've sent you a link to reset your password, please check your email", .success)
        }catch{
            LocalNotification.shared.message("\(error.localizedDescription)", .warning)
            print("Failed to reset password: \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        }catch{
            LocalNotification.shared.message("\(error.localizedDescription)", .warning)
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteUserData() async throws {
        let uid = Auth.auth().currentUser?.uid
        
        if let uid {
            let documentReference = FirestoreContants.userCollection.document(uid)
            try await documentReference.delete()
            self.signOut()
        }
    }
    
    @MainActor
    private func uploadUserData(email: String, fullname: String, id: String) async throws{
        let user = User(fullname: fullname, email: email, profileImageUrl: nil)
        
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUserData(){
        Task{ try await UserService.shared.fetchCurrentUser() }
    }
}
