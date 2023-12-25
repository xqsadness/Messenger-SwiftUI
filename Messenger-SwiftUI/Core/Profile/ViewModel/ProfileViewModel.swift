//
//  ProfileViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import Firebase

@Observable
class ProfileViewModel{
    var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    var profileImage: UIImage?
    var isLoading = false
    var nameChange = ""

    func loadImage() async throws{
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        
        guard let uiImage = UIImage(data: data) else { return }
        
        self.profileImage = uiImage
    }
    
    func upLoadAvatar(){
        self.isLoading = true
        guard let profileImage = profileImage else {
            LocalNotification.shared.message("Default profile image not found", .warning)
            self.isLoading = false
            return
        }
        
        let uid = Auth.auth().currentUser?.uid
        
        let storageRef = Storage.storage().reference().child("User_Images").child(uid ?? "")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        // Convert the image into JPEG and compress the quality to reduce its size
        let imageData = profileImage.jpegData(compressionQuality: 0.2)
        
        if let imageData{
            storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                Task{
                    let url = try await storageRef.downloadURL()
                    
                    try await self.updateProfileImageURL(userID: uid ?? "", newProfileImageUrl: url.absoluteString)
                    
                    try await UserService.shared.fetchCurrentUser()
                    
                    self.profileImage = nil
                    self.isLoading = false
                }
            }
        }
    }
    
    func updateProfileImageURL(userID: String, newProfileImageUrl: String) async throws {
        let userRef = FirestoreContants.userCollection.document(userID)
        
        let dataToUpdate: [String: Any] = [
            "profileImageUrl": newProfileImageUrl
        ]
        try await userRef.setData(dataToUpdate, merge: true)
    }
    
    func changeNameUser() async throws {
        let userID = Auth.auth().currentUser?.uid
        
        if let userID{
            if nameChange.isEmpty{
                LocalNotification.shared.message("Please enter new name", .warning)
            }else{
                let userRef = FirestoreContants.userCollection.document(userID)
                let dataToUpdate: [String: Any] = [
                    "fullname": nameChange
                ]
                try await userRef.setData(dataToUpdate, merge: true)
                try await UserService.shared.fetchCurrentUser()
                
                self.nameChange = ""
            }
        }
    }
}
