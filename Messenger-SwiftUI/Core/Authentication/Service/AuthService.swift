//
//  AuthService.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation
import Firebase

class AuthService{
    
    func login(withEmail email: String, password: String) async throws{
        
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            debugPrint("ERROR: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
}
