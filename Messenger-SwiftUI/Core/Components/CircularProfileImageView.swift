//
//  CircularProfileImageView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    var dimension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xLarge: return 80
        }
    }
}

struct CircularProfileImageView: View {
    let user: User
    let size: ProfileImageSize
    
    var body: some View {
        if let imageUrl = user.profileImageUrl{
            Image(imageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        }else{
            Image(.imgDefault)
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularProfileImageView(user: User.MOCK_USER, size: .medium)
}
