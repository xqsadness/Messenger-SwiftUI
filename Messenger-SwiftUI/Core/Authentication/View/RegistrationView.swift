//
//  RegistrationView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI
import Observation

struct RegistrationView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @Bindable var viewModel = RegistrationViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    
    var body: some View {
        VStack{
            Spacer()
            
            //logo image
            Image(.messengerLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
            
            //text field
            textfield
            
            signUp
            
            Spacer()

            Divider()
            
            signIn
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(Coordinator.shared)
}

extension RegistrationView{
    private var textfield: some View{
        VStack(spacing: 12){
            TextField("Enter your email", text: $viewModel.email)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            TextField("Enter your fullname", text: $viewModel.fullname)
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
    
    private var signUp: some View{
        Button{
            Task { try await viewModel.createUser() }
        }label: {
            Text("Sign up")
                .font(.semibold(size: 14))
                .foregroundStyle(.text2)
                .frame(width: 360, height: 44)
                .background(Color(.systemBlue))
                .cornerRadius(10)
        }
        .padding(.vertical)
    }
    
    private var signIn: some View{
        HStack(spacing: 3){
            Text("Already have an account ?")
                .font(.regular(size: 13))
            
            Text("Sign in")
                .font(.bold(size: 13))
        }
        .foregroundStyle(.blue)
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture {
            coordinator.pop()
        }
    }
}
