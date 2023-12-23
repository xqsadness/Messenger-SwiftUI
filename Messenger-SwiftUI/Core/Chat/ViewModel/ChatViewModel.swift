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
    
    let service: ChatService
    
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        obeserveMessages()
    }
    
    func obeserveMessages(){
        service.observeMessages() { messages in
            for newMessage in messages {
                // Check if the new message already exists in the current message list
                if let index = self.message.firstIndex(where: { $0.messageID == newMessage.messageID }) {
                    // If the message already exists, update its information
                    self.message[index] = newMessage
                } else {
                    // If the message is new, append it to the current message list
                    self.message.append(contentsOf: messages)
                    
                    //Scroll to the last message after a short delay for UI update
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        self.scrolledID = self.message.last
                    }
                }
            }
        }
    }
    
    func sendMessage(){
        service.sendMessage(messageText)
    }
    
    func updateUnreadMessage(lastMesage: Message?){
        if !self.message.isEmpty{
            if let lastMesage{
                service.updateUnreadMessage(idMessage: lastMesage.messageID ?? "")
            }
        }
    }
    
    func unsendMessage(idMessage: String){
        service.unsendMessage(idMessage: idMessage, isLastMessage: self.message.last?.messageID == idMessage)
    }
}
