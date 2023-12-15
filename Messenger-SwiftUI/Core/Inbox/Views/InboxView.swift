//
//  InboxView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showNewMessageView: Bool = false
    @State private var showChat: Bool = false
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        VStack{
            header
            
            ActiveNowView()
            
            ScrollView(showsIndicators: false){
                LazyVStack{
                    ForEach(viewModel.recentMessage){ message in
                        InboxRowView(message: message)
                    }
                }
                .padding(.horizontal,13)
                //                .scrollIndicators(.hidden)
                //                .listStyle(PlainListStyle())
                //                .frame(height: UIScreen.main.bounds.height - 120)
                .onChange(of: selectedUser, { _ , newValue in
                    showChat = newValue != nil
                })
                .fullScreenCover(isPresented: $showNewMessageView){
                    NewMessageView(selectedUser: $selectedUser)
                }
                .navigationDestination(isPresented: $showChat) {
                    if let user = selectedUser{
                        ChatView(user: user)
                            .navigationBarBackButtonHidden()
                    }
                }
                
            }
        }
    }
}

#Preview {
    InboxView()
}

extension InboxView{
    private var header: some View{
        HStack{
            NavigationLink(value: user) {
                CircularProfileImageView(user: user, size: .small)
            }
            
            Text("Charts")
                .font(.semibold(size: 24))
                .foregroundStyle(.text)
            
            Spacer()
            
            Button{
//                coordinator.presentFullScreen(.mewMessageView)÷
                showNewMessageView.toggle()
                self.selectedUser = nil
            }label: {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
        }
        .hAlign(.leading)
        .padding(.horizontal)
    }
}
