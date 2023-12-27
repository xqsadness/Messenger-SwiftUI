//
//  ChatService.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 15/12/2023.
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
        
        let message = Message(messageID: messageID,fromId: currentUid, toId: chatPartnerId, messageText: messageText, timestamp: Timestamp(), unread: true, isRecalled: false)
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageID).setData(messageData)
        
        recentCurrentUserRef.setData(messageData)
        recentPartnerUserRef.setData(messageData)
        
        //Send notification
        if let fcmToken = chatPartner.fcmToken, let currentUser = UserService.shared.currentUser{
            PushNotificationSender.shared.sendPushNotificationProduct(to: fcmToken, title: "You have a new message", body: "\(currentUser.firstName): \(messageText)")
        }
    }
    
    func observeMessages(limit: Int, startAfter: Timestamp?, completion: @escaping ([Message], Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        var query = FirestoreContants.messageCollection
                .document(currentUid)
                .collection(chatPartnerId)
                .order(by: "timestamp", descending: true)
                .limit(to: limit)

            if let startAfter = startAfter {
                query = query.start(after: [startAfter])
            }

            query.addSnapshotListener { snapShot, _ in
                // Filter document changes to include only added or modified changes
                guard let changes = snapShot?.documentChanges.filter({ $0.type == .added || $0.type == .modified }) else { return }

                var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })

                for (index, message) in messages.enumerated() where message.fromId != currentUid {
                    // Attach the user information to each message
                    messages[index].user = chatPartner
                }
                // Notify if a new message is sent (isSend is true) based on the number of changes
                completion(messages, changes.count == 1 ? true : false)
            }
    }
    
    func updateUnreadMessage(idMessage: String){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreContants.messageCollection.document(currentUid).collection(chatPartnerId).document(idMessage)
        let chatPartnerRef = FirestoreContants.messageCollection.document(chatPartnerId).collection(currentUid).document(idMessage)
                
        let recentMessageRef = FirestoreContants
            .messageCollection
            .document(currentUid)
            .collection("recent-messages")
            .document(chatPartnerId)
        
        let updateUnread: [String: Any] = [
            "unread": false
        ]
        
        chatPartnerRef.setData(updateUnread, merge: true)
        currentUserRef.setData(updateUnread, merge: true)
                
        recentMessageRef.setData(updateUnread, merge: true)
    }
    
    func unsendMessage(idMessage: String,isLastMessage: Bool){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreContants.messageCollection.document(currentUid).collection(chatPartnerId).document(idMessage)
        let chatPartnerRef = FirestoreContants.messageCollection.document(chatPartnerId).collection(currentUid).document(idMessage)
                
        let recentMessageCurrentUserRef = FirestoreContants
            .messageCollection
            .document(currentUid)
            .collection("recent-messages")
            .document(chatPartnerId)
        
        let recentMessagePartnerUserRef = FirestoreContants
            .messageCollection
            .document(chatPartnerId)
            .collection("recent-messages")
            .document(currentUid)
        
        let updateUnread: [String: Any] = [
            "isRecalled": true
        ]
        
        chatPartnerRef.setData(updateUnread, merge: true)
        currentUserRef.setData(updateUnread, merge: true)
               
        if isLastMessage{
            recentMessageCurrentUserRef.setData(updateUnread, merge: true)
            recentMessagePartnerUserRef.setData(updateUnread, merge: true)
        }
    }
    
}
