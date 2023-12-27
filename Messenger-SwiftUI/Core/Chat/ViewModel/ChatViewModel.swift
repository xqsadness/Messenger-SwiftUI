//
//  ChatViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 15/12/2023.
//

import Foundation
import SwiftUI
import Firebase

class ChatViewModel: ObservableObject{
    @Published var messageText = ""
    @Published var message = [Message]()
    @Published var scrolledID: Message?
    
    let service: ChatService
    private var startAfter: Timestamp? = nil
    private var limit = 20
    
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        obeserveMessages()
    }
    
    func obeserveMessages(){
        service.observeMessages(limit: limit, startAfter: startAfter) { messages, isSend in
            for newMessage in messages {
                // Check if the new message already exists in the current message list
                if let index = self.message.firstIndex(where: { $0.messageID == newMessage.messageID }) {
                    // If the message already exists, update its information
                    self.message[index] = newMessage
                } else {
                    // If the message is new, append it to the current message list
                    if isSend {
                        // If sending a message, insert the message at the beginning of the list
                        self.message.insert(contentsOf: messages, at: 0)
                        // If messages > limit message then removeLast
                        if self.message.count > self.limit{
                            self.message.removeLast()
                        }
                    } else {
                        // If not sending a message, append the message to the end of the list
                        self.message.append(contentsOf: messages)
                    }
                }
            }
            self.scrollToMessage()
        }
    }
    
    func loadMoreMessages() {
        startAfter = message.last?.timestamp
        obeserveMessages()
    }
    
    func scrollToMessage(){
        // Scroll to the first or last message after a short delay for UI update
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
        self.scrolledID = self.message.first
        //        }
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
        //Because In Chat view ForEach(viewModel.message.REVERSED()) so -> isLastMessage = self.message.first or self.message.reversed().last
        service.unsendMessage(idMessage: idMessage, isLastMessage: self.message.first?.messageID == idMessage)
    }
}

