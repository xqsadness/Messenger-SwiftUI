//
//  ProfileView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI
import Observation

struct ProfileView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Bindable var viewModel = ProfileViewModel()
    
    var body: some View {
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
                    }
                }
                
                Section{
                    Button{
                        
                    }label: {
                        Text("Log out")
                            .font(.regular(size: 16))
                            .foregroundStyle(.red)
                    }
                    
                    Button{
                        
                    }label: {
                        Text("Delete account")
                            .font(.regular(size: 16))
                            .foregroundStyle(.red)
                    }
                }
            }
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
            }
            .hAlign(.leading)
            .padding(.horizontal)
            
            VStack{
                PhotosPicker(selection: $viewModel.selectedItem){
                    if let profileImage = viewModel.profileImage{
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }else{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color(.systemGray4))
                    }
                }
                
                Text("Expensive melon")
                    .font(.semibold(size: 20))
                    .foregroundStyle(.text)
            }
        }
    }
}
