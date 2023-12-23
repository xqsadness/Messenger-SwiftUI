//
//  ForgotPasswordViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 23/12/2023.
//

import Foundation

@Observable
class ForgotPasswordViewModel{
    
    var isLoading = false
    var email = ""
    
    func sendResetPassword(){
        Task{
            isLoading = true
            try await AuthService.shared.resetPassword(email: email)
            isLoading = false
        }
    }
}

