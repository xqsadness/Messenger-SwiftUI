//
//  ProfileViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI
import PhotosUI
import Observation

@Observable
class ProfileViewModel{
    
    var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    var profileImage: Image?
    
    func loadImage() async throws{
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        
        guard let uiImage = UIImage(data: data) else { return }
        
        self.profileImage = Image(uiImage: uiImage)
    }
    
}
