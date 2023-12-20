//
//  NewMessageViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 15/12/2023.
//

import Foundation
import Firebase
import Combine

@MainActor
class NewMessageViewModel: ObservableObject{
    @Published var users = [User]()
    @Published var searchText = ""
    
    var cancellables: Set<AnyCancellable> = []
    
    init(){
        Task { try await fetchUsers() }
        
        searchUser()
    }
    
    func fetchUsers() async throws{
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter({ $0.id != currenUID })
    }
    
    func searchUser(){
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .combineLatest($users)
            .map{ searchText, users in
                guard !searchText.isEmpty else{
                    return users
                }
                
                return users.filter( { $0.fullname.lowercased().contains(searchText.lowercased()) } )
            }
            .sink { [weak self] returnedSearch in
                guard let self = self else { return }
                
                self.users = returnedSearch
                if searchText.isEmpty {
                    Task { try await self.fetchUsers() }
                }
            }
            .store(in: &cancellables)
        
        if searchText.isEmpty{
            Task { try await fetchUsers() }
        }
    }
}
