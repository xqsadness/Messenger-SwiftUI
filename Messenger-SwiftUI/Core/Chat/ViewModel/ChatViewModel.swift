//
//  ChatViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 15/12/2023.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject{
    @Published var messageText = ""
    @Published var message = [Message]()
    @Published var scrolledID: Message?

    let servicce: ChatService
    
    init(user: User) {
        self.servicce = ChatService(chatPartner: user)
        obeserveMessages()
    }
    
    func obeserveMessages(){
        servicce.observeMessages() { messages in
            self.message.append(contentsOf: messages)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.scrolledID = self.message.last
            }
        }
    }
    
    func sendMessage(){
        servicce.sendMessage(messageText)
    }
}
