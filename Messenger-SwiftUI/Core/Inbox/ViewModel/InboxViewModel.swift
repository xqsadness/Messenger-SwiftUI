//
//  InboxViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import SwiftUI
import Combine
import Firebase

class InboxViewModel: ObservableObject {    
    
    @Published var currentUser: User?
    @Published var recentMessage = [Message]()
    @Published var isLoading:Bool = true
    
    private var cancelables = Set<AnyCancellable>()
    private var service = InboxService()
    
    init(){
        setupSubcribers()
        service.observeRecentMessages()
    }
    
    private func setupSubcribers(){
        UserService.shared.$currentUser
            .combineLatest(service.$documentChanges)
            .sink { [weak self] user, changes in
                self?.currentUser = user
                self?.loadInitMessages(fromChanges: changes)
                
                if user != nil{
                    self?.isLoading = false
                }
            }
            .store(in: &cancelables)
    }
    
    private func loadInitMessages(fromChanges changes: [DocumentChange]){
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        for i in 0 ..< messages.count{
            let message = messages[i]
            
            UserService.fetchUser(withUid: message.chatPartnerID) {  user in
                messages[i].user = user
                
                if let existingIndex = self.recentMessage.firstIndex(where: { $0.messageID == message.chatPartnerID }) {
                    // Message with the same ID already exists, update it
                    self.recentMessage[existingIndex] = messages[i]
                } else {
                    // Message doesn't exist, append it
                    self.recentMessage.append(messages[i])
                }
                
            }
        }
    }
}
