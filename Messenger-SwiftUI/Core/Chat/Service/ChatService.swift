//
//  ChatService.swift
//  Messenger-SwiftUI
//
//  Created by darktech4 on 15/12/2023.
//

import Foundation
import Firebase

struct ChatService{
    
    let chatPartner: User
    
    func sendMessage(_ messageText: String){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreContants.messageCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreContants.messageCollection.document(chatPartnerId).collection(currentUid)
        
        let recentCurrentUserRef = FirestoreContants.messageCollection.document(currentUid).collection("recent-messages").document(chatPartnerId)
        let recentPartnerUserRef = FirestoreContants.messageCollection.document(chatPartnerId).collection("recent-messages").document(currentUid)
        
        let messageID = currentUserRef.documentID
        
        let message = Message(messageID: messageID,fromId: currentUid, toId: chatPartnerId, messageText: messageText, timestamp: Timestamp())
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageID).setData(messageData)
        
        recentCurrentUserRef.setData(messageData)
        recentPartnerUserRef.setData(messageData)
    }
    
    func observeMessages(completion: @escaping ([Message]) -> Void ){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let query = FirestoreContants.messageCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapShot, _ in
            guard let changes = snapShot?.documentChanges.filter({ $0.type == .added }) else { return }
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
            
            for (index, message) in messages.enumerated() where message.fromId != currentUid{
                messages[index].user = chatPartner
            }
            
            completion(messages)
        }
    }
}
