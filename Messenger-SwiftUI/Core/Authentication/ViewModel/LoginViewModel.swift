//
//  LoginViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation

@Observable
class LoginViewModel{
    
    var isLoading = false
    
     var email = ""
     var password = ""
    
    func login() async throws{
        isLoading = true
        try await AuthService.shared.login(withEmail: email, password: password)
        isLoading = false
    }
}
