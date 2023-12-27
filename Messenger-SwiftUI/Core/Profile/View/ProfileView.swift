//
//  ProfileView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    enum FocusedField {
        case newName
    }
    
    @EnvironmentObject var coordinator: Coordinator
    @Bindable var viewModel = ProfileViewModel()
    @FocusState private var focusedField: FocusedField?
    
    @State var isShowDarkMode = false
    @State private var showingAlertDeleteAccount = false
    @State private var showingLogout = false
    @State private var showingChangeName = false
    
    private var user: User? {
        return UserService.shared.currentUser ?? nil
    }
    
    var body: some View {
        VStack{
            if isShowDarkMode{
                ChangeDarkLightView(isShowDarkMode: $isShowDarkMode)
                    .transition(.move(edge: .trailing))
            }else{
                VStack{
                    //header
                    header
                    
                    //list
                    List{
                        Section{
                            ForEach(SettingOptionsViewModel.allCases){ option in
                                HStack{
                                    Image(systemName: option.imageName)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(option.imageBackgroundColor)
                                    
                                    Text(option.title)
                                        .foregroundStyle(.text)
                                        .font(.regular(size: 16))
                                }
                                .onTapGesture {
                                    optionOntap(option: option)
                                }
                            }
                        }
                        
                        Section{
                            logout
                            
                            deleteAccount
                        }
                    }
                }
                .transition(.move(edge: .leading))
                .opacity(isShowDarkMode ? 0 : 1)
                .overlay{
                    LoadingView(show: $viewModel.isLoading)
                }
            }
        }
    }
    
    func optionOntap(option: SettingOptionsViewModel){
        switch option{
        case .darkMode:
            withAnimation {
                isShowDarkMode.toggle()
            }
        case .activeStatus:
            print(option)
        case .accessibility:
            print(option)
        case .privacy:
            print(option)
        case .notifications:
            coordinator.push(.notificationSettingView)
        }
    }
}

#Preview {
    ProfileView()
}

extension ProfileView{
    private var header: some View{
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.text)
                
                Text("Back")
                    .font(.semibold(size: 16))
                    .foregroundStyle(.text)
                
                Spacer()
                
                if viewModel.profileImage != nil{
                    Button{
                        viewModel.upLoadAvatar()
                    }label: {
                        Text("Save")
                            .font(.semibold(size: 16))
                            .foregroundStyle(.blue)
                    }
                }
            }
            .hAlign(.leading)
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.pop()
            }
            
            avatar
        }
    }
    
    private var avatar: some View{
        VStack{
            PhotosPicker(selection: $viewModel.selectedItem){
                VStack{
                    if let profileImage = viewModel.profileImage{
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }else{
                        CircularProfileImageView(user: user, size: .xxLarge)
                    }
                }
                .overlay {
                    ZStack(alignment: .bottomTrailing){
                        Color.black.opacity(0.1)
                            .clipShape(Circle())
                        
                        VStack{
                            Rectangle()
                                .foregroundStyle(.black)
                                .cornerRadius(3)
                        }
                        .frame(width: 25, height: 20)
                        .overlay {
                            Image(systemName: "camera.fill")
                                .imageScale(.medium)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            
            name
        }
    }
    
    private var name: some View{
        HStack(spacing: 10){
            if showingChangeName{
                HStack{
                    TextField("Name", text: $viewModel.nameChange)
                        .keyboardType(.default)
                        .textContentType(.name)
                        .foregroundStyle(.text)
                        .focused($focusedField, equals: .newName)
                    
                    Button{
                        Task{
                            try await viewModel.changeNameUser()
                            
                            withAnimation {
                                focusedField = nil
                                showingChangeName.toggle()
                            }
                        }
                    }label: {
                        Text("OK")
                            .font(.semibold(size: 14))
                            .foregroundStyle(.text)
                    }
                }
                .frame(width: 200, alignment: .center)
            }else{
                Text("\(user?.fullname ?? "")")
                    .font(.semibold(size: 20))
                    .foregroundStyle(.text)
                
                Image(systemName: "pencil.and.outline")
                    .imageScale(.medium)
                    .foregroundStyle(.text)
                    .onTapGesture {
                        withAnimation {
                            showingChangeName.toggle()
                            focusedField = .newName
                        }
                    }
            }
        }
        .padding(.top,5)
    }
    
    
    private var logout: some View{
        Button{
            showingLogout.toggle()
        }label: {
            Text("Log out")
                .font(.regular(size: 16))
                .foregroundStyle(.red)
        }
        .alert(isPresented: $showingLogout) {
            Alert(
                title: Text("Confirm logout"),
                message: Text("Are you sure want to sign out?"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {}
                ),
                secondaryButton: .destructive(
                    Text("Logout"),
                    action: {
                        AuthService.shared.signOut()
                        coordinator.pop()
                    }
                )
            )
        }
    }
    
    private var deleteAccount: some View{
        Button{
            showingAlertDeleteAccount.toggle()
        }label: {
            Text("Delete account")
                .font(.regular(size: 16))
                .foregroundStyle(.red)
        }
        .alert(isPresented: $showingAlertDeleteAccount) {
            Alert(
                title: Text("Confirm account deletion"),
                message: Text("Once your account is deleted, you will not be able to restore it. Are you sure you want to delete it?"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {}
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        Task{
                            try await AuthService.shared.deleteUserData()
                            coordinator.pop()
                        }
                    }
                )
            )
        }
    }
}
