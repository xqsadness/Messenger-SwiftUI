//
//  ChatView.swift
//  Messenger-SwiftUI
//
//  Created by darktech4 on 13/12/2023.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var messageText = ""
    
    var body: some View {
        VStack{
            title
            
            ScrollView(showsIndicators: false){
                //header
                header
                
                //messages
                ForEach(0...15, id: \.self){ message in
                    ChatMessageCell(isFromCurrentUser: Bool.random())
                }
            }
            
            //message input
            Spacer()
            
            messageInput
        }
    }
}

#Preview {
    ChatView()
}

extension ChatView{
    private var title: some View{
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
        .overlay{
            Text("Thai Nga")
                .font(.semibold(size: 20))
                .foregroundStyle(.text)
        }
        .padding(.bottom)
        .onTapGesture {
            coordinator.pop()
        }
    }
    
    private var header: some View{
        VStack{
            CircularProfileImageView(user: User.MOCK_USER, size: .xLarge)
            
            VStack(spacing: 4){
                Text("Thai Nga")
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
            TextField("Message...", text: $messageText, axis: .vertical)
                .padding(12)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.regular(size: 14))
            
            Button{
                
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
