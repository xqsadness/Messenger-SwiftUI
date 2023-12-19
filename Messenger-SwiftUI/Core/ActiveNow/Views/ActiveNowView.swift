//
//  ActiveNowView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 23){
                if viewModel.isLoading{
                    loadDataShimmering
                }else{
                    ForEach(viewModel.users){ user in
                        NavigationLink(value: Route.chatView(user)) {
                            avatarName(user: user)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                        }
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

extension ActiveNowView{
    
    private var loadDataShimmering: some View{
        HStack{
            ForEach(0..<4) { _ in
                HStack(spacing: 10){
                    Circle()
                        .frame(width: 56, height: 56, alignment: .center)
                        .foregroundStyle(.text).opacity(0.7)
                }
                .shimmering(bandSize: 1)
            }
        }
        .hAlign(.leading)
    }
    
    private func avatarName(user: User) -> some View{
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
            
            Text("\(user.firstName)")
                .foregroundStyle(.gray)
                .font(.semibold(size: 12))
        }
    }
}
