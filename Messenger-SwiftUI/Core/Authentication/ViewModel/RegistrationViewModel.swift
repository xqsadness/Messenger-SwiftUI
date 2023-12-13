//
//  RegistrationViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation
import Observation

@Observable
class RegistrationViewModel{
    
    var email = ""
    var password = ""
    var fullname = ""
    
    func createUser() async throws{
        try await AuthService().createUser(withEmail: email, password: password, fullname: fullname)
    }
    
}
