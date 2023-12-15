//
//  ChatViewModel.swift
//  Messenger-SwiftUI
//
//  Created by darktech4 on 15/12/2023.
//

import Foundation

class ChatViewModel: ObservableObject{
    @Published var messageText = ""
    @Published var message = [Message]()
    
    let servicce: ChatService
    
    init(user: User) {
        self.servicce = ChatService(chatPartner: user)
        obeserveMessages()
    }
    
    func obeserveMessages(){
        servicce.observeMessages() { messages in
            self.message.append(contentsOf: messages)
        }
    }
    
    func sendMessage(){
        servicce.sendMessage(messageText)
    }
}
