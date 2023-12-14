//
//  InboxViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import SwiftUI
import Combine
import Firebase


class InboxViewModel: ObservableObject {    
    
    @Published var currentUser: User?
    
    private var cancelables = Set<AnyCancellable>()
    
    init(){
        setupSubcribers()
    }
    
    private func setupSubcribers(){
        UserService.shared.$currentUser
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancelables)
    }
}
