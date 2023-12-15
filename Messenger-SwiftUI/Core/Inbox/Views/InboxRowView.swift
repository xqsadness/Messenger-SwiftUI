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
            
            VStack(alignment: .leading, spacing: 4){
                Text("\(message.user?.fullname ?? "")")
                    .foregroundStyle(.text)
                    .font(.bold(size: 14))
                
                Text("\(message.messageText)")
                    .foregroundStyle(.gray)
                    .font(.regular(size: 14))
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack{
                Text("\(message.timestamp.formatTimestamp())")
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

extension Timestamp{
    func formatTimestamp() -> String {
        let dateFormatter = DateFormatter()
        
        let currentDate = Date()
        let messageDate = Date(timeIntervalSince1970: TimeInterval(self.seconds))
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: messageDate, to: currentDate)
        
        if let dayDifference = components.day, dayDifference == 0 {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        return dateFormatter.string(from: messageDate)
    }
}
