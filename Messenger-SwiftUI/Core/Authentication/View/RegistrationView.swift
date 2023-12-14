//
//  RegistrationView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI

struct RegistrationView: View {
    enum FocusedField {
        case email, password, fullname
    }
    
    @EnvironmentObject var coordinator: Coordinator
    
    @State var viewModel = RegistrationViewModel()
    @FocusState private var focusedField: FocusedField?
    
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
            
            signUpText
            
            Spacer()
            
            Divider()
            
            signInText
        }
        .overlay{
            LoadingView(show: $viewModel.isLoading)
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
                .focused($focusedField, equals: .email)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            TextField("Enter your fullname", text: $viewModel.fullname)
                .focused($focusedField, equals: .fullname)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            SecureField("Enter your password", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
        }
        .onSubmit {
            signUp()
        }
    }
    
    private var signUpText: some View{
        Button{
            signUp()
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
    
    private var signInText: some View{
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
    
    //MARK: - funcs
    private func signUp(){
        if viewModel.email.isEmpty {
            focusedField = .email
        }else if viewModel.fullname.isEmpty{
            focusedField = .fullname
        }else if viewModel.password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            Task { try await viewModel.createUser()
                if AuthService.shared.userSession != nil{
                    coordinator.pop()
                }
            }
        }
    }
}
