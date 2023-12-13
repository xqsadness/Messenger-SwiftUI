//
//  LoginView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI
import Observation

struct LoginView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Bindable var viewModel = LoginViewModel()
    
    var body: some View {
        VStack{
            Spacer()
            
            //logo image
            Image(.messengerLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .padding()
            
            //text field
            textfield
            
            //forgot password
            forgotPassword
            
            //login button
            loginButton
            
            //facebook login
            facebookLogin
            
            Spacer()

            //sign up link
            signupLink
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(Coordinator.shared)
}

extension LoginView{
    private var textfield: some View{
        VStack(spacing: 12){
            TextField("Enter your email", text: $viewModel.email)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            SecureField("Enter your password", text: $viewModel.password)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
        }
    }
    
    private var forgotPassword: some View{
        Button{
            
        }label: {
            Text("Forgot password?")
                .font(.bold(size: 13))
                .padding(.top)
                .padding(.trailing,28)
        }
        .hAlign(.trailing)
    }
    
    private var loginButton: some View{
        Button{
            Task { try await viewModel.login() }
        }label: {
            Text("Login")
                .font(.semibold(size: 14))
                .foregroundStyle(.text2)
                .frame(width: 360, height: 44)
                .background(Color(.systemBlue))
                .cornerRadius(10)
        }
        .padding(.vertical)
    }
    
    private var facebookLogin: some View{
        VStack{
            HStack{
                Rectangle()
                    .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5 )
                
                Text("OR")
                    .font(.semibold(size: 12))
                
                Rectangle()
                    .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5 )
            }
            .foregroundStyle(.gray).opacity(0.8)
            
            HStack{
                Image(.fbLogo)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Continue with fabebook")
                    .font(.bold(size: 13))
                    .foregroundStyle(.blue)
            }
            .padding(.top, 8)
        }
    }
    
    private var signupLink: some View{
        VStack{
            Divider()
            
            HStack(spacing: 3){
                Text("Don't have an account?")
                    .font(.regular(size: 13))
                
                Text("Sign up")
                    .font(.bold(size: 13))
            }
            .foregroundStyle(.blue)
            .padding(.vertical)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.push(.registrationView)
            }
        }
    }
}
