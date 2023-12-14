//
//  InboxView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var user = User.MOCK_USER
    
    var body: some View {
        VStack{
            header
            
            ActiveNowView()
            
            ScrollView(showsIndicators: false){
                LazyVStack{
                    ForEach(0...10, id: \.self){ message in
                        InboxRowView()
                    }
                }
                .padding(.horizontal,13)
                //                .scrollIndicators(.hidden)
                //                .listStyle(PlainListStyle())
                //                .frame(height: UIScreen.main.bounds.height - 120)
            }
        }
    }
}

#Preview {
    InboxView()
}

extension InboxView{
    private var header: some View{
        HStack{
            NavigationLink(value: user) {
                CircularProfileImageView(user: user, size: .small)
            }
            
            Text("Charts")
                .font(.semibold(size: 24))
                .foregroundStyle(.text)
            
            Spacer()
            
            Button{
                coordinator.presentFullScreen(.mewMessageView)
            }label: {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
        }
        .hAlign(.leading)
        .padding(.horizontal)
    }
}
