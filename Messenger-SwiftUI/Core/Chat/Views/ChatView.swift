//
//  ChatView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ChatViewModel
    
    let user: User
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack{
            title
            
            ScrollView(showsIndicators: false){
                //header
                header
                
                //messages
                ForEach(viewModel.message){ message in
                    ChatMessageCell(message: message)
                }
            }
            
            //message input
            Spacer()
            
            messageInput
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}

extension ChatView{
    private var title: some View{
        HStack{
            Image(systemName: "chevron.left")
                .imageScale(.medium)
                .foregroundStyle(.text)
            
            Text("Back")
                .font(.semibold(size: 14.5))
                .foregroundStyle(.text)
        }
        .hAlign(.leading)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .overlay{
            Text(user.fullname)
                .font(.semibold(size: 20))
                .foregroundStyle(.text)
        }
        .padding(.bottom,3)
        .onTapGesture {
            dismiss()
        }
    }
    
    private var header: some View{
        VStack{
            CircularProfileImageView(user: user, size: .xLarge)
            
            VStack(spacing: 4){
                Text(user.fullname)
                    .font(.semibold(size: 17))
                    .foregroundStyle(.text)
                
                Text("Messenger")
                    .font(.regular(size: 13.5))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.bottom)
    }
    
    private var messageInput: some View{
        ZStack(alignment: .trailing){
            TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                .padding(12)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.regular(size: 14))
            
            Button{
                viewModel.sendMessage()
                viewModel.messageText = ""
            }label: {
                Text("Send")
                    .font(.bold(size: 13.5))
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}
