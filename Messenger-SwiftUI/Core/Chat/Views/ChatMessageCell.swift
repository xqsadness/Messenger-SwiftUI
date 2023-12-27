//
//  ChatMessageCell.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    
    @StateObject var viewModel: ChatViewModel
    @State private var showTime = false
    @State private var showingAlertUnsend = false
    @State private var isAppeared = false
    @State private var isShowTime = false
    
    var body: some View {
        HStack{
            if message.isFromCurrentUser{
                Spacer()
                
                messageFromCurrenUser
            }else{
                messageFromPartner
            }
        }
        .padding(.horizontal, 8)
        .scrollTransition(topLeading: .interactive,bottomTrailing: .interactive){ content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                .blur(radius: phase.isIdentity ? 0 : 10)
        }
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -50)
        .onAppear{
            withAnimation {
                isAppeared = true
            }
        }
        .alert(isPresented: $showingAlertUnsend) {
            Alert(
                title: Text("Confirm unsend message"),
                message: Text("Once you unsend a message, you cannot undo it"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {}
                ),
                secondaryButton: .destructive(
                    Text("Confirm"),
                    action: {
                        if let id = message.messageID{
                            viewModel.unsendMessage(idMessage: id)
                        }
                    }
                )
            )
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
    
    private var messageFromCurrenUser: some View{
        VStack{
            timeMessage(size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            
            if message.isRecalled{
                unsendMessageText(text: "You unsend a message", size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            }else{
                messageText(bgr: Color(.systemBlue), fgr: .white, size: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowTime.toggle()
            }
        }
    }
    
    private var messageFromPartner: some View{
        HStack(alignment: .bottom, spacing: 8){
            CircularProfileImageView(user: message.user, size: .xxSmall)
            
            VStack{
                if message.isRecalled{
                    timeMessage(size: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                    
                    unsendMessageText(text: "\(message.user?.firstName ?? "unsend a message") unsend a message", size: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                }else{
                    timeMessage(size: .infinity, alignment: .leading)
                    
                    messageText(bgr: Color(.systemGray5), fgr: .text, size: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
        }
        .onTapGesture {
            withAnimation {
                isShowTime.toggle()
            }
        }
    }
    
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
                contextMenu
            }
            .frame(maxWidth: size, alignment: alignment)
    }
    
    private var contextMenu: some View{
        VStack{
            Button{
                let pasteboard = UIPasteboard.general
                pasteboard.string = message.messageText
            }label: {
                labelWithImage(symbol: "wallet.pass", text: "Coppy")
            }
            
            if UserService.shared.currentUser?.id == message.fromId{
                Button{
                    showingAlertUnsend.toggle()
                }label: {
                    labelWithImage(symbol: "minus.circle", text: "Unsend")
                }
            }
            
            Text("Time: " + message.timestampString)
                .font(.regular(size: 14))
                .foregroundStyle(.text)
        }
    }
    
    private func unsendMessageText(text: String, size: CGFloat, alignment: Alignment) -> some View{
        Text("\(text)")
            .font(.regular(size: 15))
            .padding(12)
            .foregroundStyle(.text).opacity(0.5)
            .overlay(
                UnevenRoundedRectangle(cornerRadii: message.isFromCurrentUser ? .init(topLeading: 14, bottomLeading: 14, topTrailing: 14) : .init(topLeading: 14, bottomTrailing: 14, topTrailing: 14))
                    .inset(by: 0.5)
                    .stroke(Color.text.opacity(0.3), lineWidth: 0.7)
            )
            .frame(maxWidth: size, alignment: alignment)
    }
    
    private func timeMessage(size: CGFloat, alignment: Alignment) -> some View{
        Group{
            if isShowTime{
                Text(message.timestampString)
                    .font(.regular(size: 13))
                    .foregroundStyle(.text).opacity(0.6)
                    .frame(maxWidth: size, alignment: alignment)
                    .padding(.vertical,2)
            }
        }
    }
}
