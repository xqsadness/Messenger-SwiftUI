//
//  ActiveNowView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 23){
                ForEach(0...10, id: \.self){ user in
                    VStack{
                        ZStack(alignment: .bottomTrailing){
                            CircularProfileImageView(user: User.MOCK_USER, size: .medium)
                            
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 18, height: 18)
                                
                                Circle()
                                    .fill(.green)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        
                        Text("James")
                            .foregroundStyle(.gray)
                            .font(.semibold(size: 12))
                    }
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                            .blur(radius: phase.isIdentity ? 0 : 10)
                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
    }
}

#Preview {
    ActiveNowView()
}
