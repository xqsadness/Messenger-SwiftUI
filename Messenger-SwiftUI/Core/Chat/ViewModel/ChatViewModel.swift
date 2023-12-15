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

    let user: User
    
    init(user: User) {
        self.user = user
        obeserveMessages()
    }
    
    func obeserveMessages(){
        MessageService.observeMessages(chatPartner: user) { messages in
            self.message.append(contentsOf: messages)
        }
    }
    
    func sendMessage(){
        MessageService.sendMessage(messageText, toUser: user)
    }
}
