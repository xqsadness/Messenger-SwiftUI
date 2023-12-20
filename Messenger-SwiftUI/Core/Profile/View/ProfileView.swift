//
//  ProfileView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Bindable var viewModel = ProfileViewModel()
    
    @State var isShowDarkMode = false
    @State private var showingAlertDeleteAccount = false
    
    let user: User
    
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
                                        print(option)
                                    }
                                }
                            }
                        }
                        
                        Section{
                            Button{
                                AuthService.shared.signOut()
                                coordinator.pop()
                            }label: {
                                Text("Log out")
                                    .font(.regular(size: 16))
                                    .foregroundStyle(.red)
                            }
                            
                            Button{
                                showingAlertDeleteAccount.toggle()
                            }label: {
                                Text("Delete account")
                                    .font(.regular(size: 16))
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
                .transition(.move(edge: .leading))
                .opacity(isShowDarkMode ? 0 : 1)
            }
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

#Preview {
    ProfileView(user: User.MOCK_USER)
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
            }
            .hAlign(.leading)
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.pop()
            }
            
            VStack{
                PhotosPicker(selection: $viewModel.selectedItem){
                    if let profileImage = viewModel.profileImage{
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }else{
                        CircularProfileImageView(user: user, size: .xxLarge)
                    }
                }
                
                Text("\(user.fullname)")
                    .font(.semibold(size: 20))
                    .foregroundStyle(.text)
            }
        }
    }
}
