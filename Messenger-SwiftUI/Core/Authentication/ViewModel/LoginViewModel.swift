//
//  LoginViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import Foundation
import Observation

@Observable
class LoginViewModel{
    
    var email = ""
    var password = ""
    
    func login() async throws{
       try await AuthService().login(withEmail: email, password: password)
    }
}
