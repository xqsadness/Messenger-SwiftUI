//
//  ForgotPasswordView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 23/12/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    enum FocusedField {
        case email
    }
    
    @EnvironmentObject var coordinator: Coordinator
    
    @State var viewModel = ForgotPasswordViewModel()
    @FocusState private var focusedField: FocusedField?

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
            
            //login button
            resetButton
            
            Text("Enter the email address associated to your account. We will send you a link to reset your password.")
                .foregroundStyle(.text).opacity(0.7)
                .font(.medium(size: 13))
                .hAlign(.center)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            //sign up link
            signinLink
        }
        .overlay{
            LoadingView(show: $viewModel.isLoading)
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(Coordinator.shared)
}

extension ForgotPasswordView{
    private var textfield: some View{
        VStack(spacing: 12){
            TextField("Enter your email", text: $viewModel.email)
                .focused($focusedField, equals: .email)
                .font(.regular(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
        }
        .onSubmit {
            send()
        }
    }
    
    private var resetButton: some View{
        Button{
            send()
        }label: {
            Text("Send")
                .font(.semibold(size: 14))
                .foregroundStyle(.text2)
                .frame(width: 360, height: 44)
                .background(Color(.systemBlue))
                .cornerRadius(10)
        }
        .padding(.vertical)
    }
    
    private var signinLink: some View{
        VStack{
            Divider()
            
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
    
    //MARK: - funcs
    private func send(){
        if viewModel.email.isEmpty {
            focusedField = .email
        } else {
            focusedField = nil
            viewModel.sendResetPassword()
            coordinator.pop()
        }
    }
}
