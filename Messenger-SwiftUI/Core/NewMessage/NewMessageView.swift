//
//  NewMessageView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct NewMessageView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var searchText = ""
    
    var body: some View {
        VStack{
            header
            
            ScrollView(showsIndicators: false){
                TextField("To: ", text: $searchText)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(Color(.systemGroupedBackground))
                
                Text("CONTACTS")
                    .foregroundStyle(.gray)
                    .font(.regular(size: 13))
                    .hAlign(.leading)
                    .padding()
                
                ForEach(0...30, id: \.self){ user in
                    VStack(spacing: 12){
                        HStack{
                            CircularProfileImageView(user: User.MOCK_USER, size: .small)
                            
                            Text("Expensive melon")
                                .font(.semibold(size: 14))
                                .foregroundStyle(.text)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading,40)
                    }
                }
            }
        }
    }
}

#Preview {
    NewMessageView()
}

extension NewMessageView{
    private var header: some View{
        HStack{
            Button{
                coordinator.dissmissFullscreenCover()
            }label: {
                Text("Cancel")
                    .foregroundStyle(.text)
                    .font(.semibold(size: 16))
            }
            .hAlign(.leading)
            .overlay {
                Text("New Message")
                    .foregroundStyle(.text)
                    .font(.semibold(size: 17))
            }
        }
        .padding(.horizontal)
    }
}
