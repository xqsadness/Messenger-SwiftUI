//
//  ChatMessageCell.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    @State private var showTime = false
    
    var body: some View {
        HStack{
            if message.isFromCurrentUser{
                Spacer()
                
                messageText(bgr: Color(.systemBlue), fgr: .white, size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                
            }else{
                HStack(alignment: .bottom, spacing: 8){
                    CircularProfileImageView(user: message.user, size: .xxSmall)
                    
                    messageText(bgr: Color(.systemGray5), fgr: .text, size: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .scrollTransition(topLeading: .interactive,bottomTrailing: .interactive){ content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                .blur(radius: phase.isIdentity ? 0 : 10)
        }
    }
    
    @ViewBuilder
    func labelWithImage(symbol: String, text: String) -> some View{
        HStack{
            Image(systemName: symbol)
                .imageScale(.medium)
                .foregroundStyle(.text)
            
            Text(text)
                .font(.regular(size: 14))
                .foregroundStyle(.text)
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
    
    private func messageText(bgr: Color, fgr: Color, size: CGFloat, alignment: Alignment) -> some View{
        Text("\(message.messageText)")
            .font(.medium(size: 15))
            .padding(12)
            .background(bgr)
            .foregroundStyle(fgr)
            .clipShape(shapeBubble)
            .contextMenu {
                Button{
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = message.messageText
                }label: {
                    labelWithImage(symbol: "wallet.pass", text: "Coppy")
                }
                
                if UserService.shared.currentUser?.id == message.fromId{
                    Button{
                        
                    }label: {
                        labelWithImage(symbol: "x.circle", text: "Unsend")
                    }
                }
                
                Text(message.timestampString)
                    .font(.regular(size: 14))
                    .foregroundStyle(.text)
            }
            .frame(maxWidth: size, alignment: alignment)
    }
}

