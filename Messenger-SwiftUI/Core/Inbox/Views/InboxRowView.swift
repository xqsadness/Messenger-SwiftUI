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
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            CircularProfileImageView(user: message.user, size: .medium)
            
            VStack(alignment: .leading, spacing: 15){
                Text("\(message.user?.fullname ?? "")")
                    .foregroundStyle(.text)
                    .font(.bold(size: 14))
                
                Text("\(message.id == UserService.shared.currentUser?.id ? "You: " : "") \(message.messageText)")
                    .foregroundStyle(.gray)
                    .font(.regular(size: 14))
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack{
                Text("\(message.timestampString)")
                    .font(.regular(size: 14))
                    .foregroundStyle(.gray)
                
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
            }
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
