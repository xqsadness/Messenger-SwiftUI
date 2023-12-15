//
//  NewMessageViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 15/12/2023.
//

import Foundation
import Firebase

@Observable
class NewMessageViewModel{
    var users = [User]()
    
    init(){
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws{
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter({ $0.id != currenUID })
    }
}
