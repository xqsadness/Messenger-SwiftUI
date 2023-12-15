//
//  ChatMessageCell.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    @State private var isAppeared = false
    
    var body: some View {
        HStack{
            if message.isFromCurrentUser{
                Spacer()
                
                Text("\(message.messageText)")
                    .font(.medium(size: 15))
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundStyle(.text2)
                    .clipShape(shapeBubble)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            }else{
                HStack(alignment: .bottom, spacing: 8){
                    CircularProfileImageView(user: User.MOCK_USER, size: .xxSmall)
                    
                    Text("\(message.messageText)")
                        .font(.medium(size: 15))
                        .padding(12)
                        .background(Color(.systemGray5))
                        .foregroundStyle(.text)
                        .clipShape(shapeBubble)
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -50)
        .onAppear {
            withAnimation {
                isAppeared = true
            }
        }
    }
}

extension ChatMessageCell{
    private var shapeBubble: some Shape{
        if message.isFromCurrentUser{
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 14, bottomLeading: 14, topTrailing: 14))
        }else{
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 14, bottomTrailing: 14, topTrailing: 14))
        }
    }
}
