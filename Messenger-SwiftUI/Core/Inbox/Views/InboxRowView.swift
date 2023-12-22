//
//  InboxRowView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import Firebase

struct InboxRowView: View {
    @State private var isAppeared = false
    
    let message: Message
    
    var unread: Bool{
        return UserService.shared.currentUser?.id != message.fromId && message.unread
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            CircularProfileImageView(user: message.user, size: .medium)
            
            VStack(alignment: .leading, spacing: 13){
                Text("\(message.user?.fullname ?? "")")
                    .foregroundStyle(.text)
                    .font(unread ? .bold(size: 14) : .medium(size: 14))
                
                messageView
            }

            timeMessage
        }
        .frame(height: 72)
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -50)
        .onAppear {
            withAnimation {
                isAppeared = true
            }
        }
        .scrollTransition(topLeading: .interactive,bottomTrailing: .interactive){ content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                .blur(radius: phase.isIdentity ? 0 : 10)
        }
    }
}

extension InboxRowView{
    
    private var messageView: some View{
        if message.isRecalled{
            Text("\(message.fromId == UserService.shared.currentUser?.id ? "You" : "\(message.user?.firstName ?? "")") unsend a message")
                .foregroundStyle(unread ? .text : .gray)
                .font(unread ? .bold(size: 14) : .regular(size: 14))
                .lineLimit(1)
                .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
        }else{
            Text("\(message.fromId == UserService.shared.currentUser?.id ? "You: " : "")\(message.messageText)")
                .foregroundStyle(unread ? .text : .gray)
                .font(unread ? .bold(size: 14) : .regular(size: 14))
                .lineLimit(1)
                .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
        }
    }
    
    private var timeMessage: some View{
        HStack{
            Text("\(message.timestampString)")
                .foregroundStyle(unread ? .text : .gray)
                .font(unread ? .bold(size: 14) : .regular(size: 14))
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(unread ? .text : .gray)
        }
    }
}
