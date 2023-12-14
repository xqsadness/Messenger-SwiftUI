//
//  RegistrationViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation

@Observable
class RegistrationViewModel{
    
    var isLoading = false
    
    var email = ""
    var password = ""
    var fullname = ""
    
    func createUser() async throws{
        isLoading = true
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
        isLoading = false
    }
}

