//
//  ActiveNowViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 16/12/2023.
//

import Foundation
import Firebase

class ActiveNowViewModel: ObservableObject{
    @Published var users = [User]()
    @Published var isLoading = true
    
    init(){
        Task{ try await fetchUser() }
    }
    
    @MainActor
    private func fetchUser() async throws{
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers(limit: 10)
        self.users = users.filter({ $0.id != currenUID })
        isLoading = false
    }
}
