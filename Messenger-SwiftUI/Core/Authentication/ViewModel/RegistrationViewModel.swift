//
//  RegistrationViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation

@Observable
class RegistrationViewModel{
    
    var email = ""
    var password = ""
    var fullname = ""
    
    func createUser() async throws{
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
    }
    
}
