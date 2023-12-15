//
//  NewMessageView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct NewMessageView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedUser: User?
    
    @State private var searchText = ""
    @State private var viewModel = NewMessageViewModel()
    
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
                
                ForEach(viewModel.users){ user in
                    VStack(spacing: 12){
                        HStack{
                            CircularProfileImageView(user: user, size: .small)
                            
                            Text("\(user.fullname)")
                                .font(.semibold(size: 14))
                                .foregroundStyle(.text)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading,40)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewMessageView(selectedUser: .constant(User.MOCK_USER))
}

extension NewMessageView{
    private var header: some View{
        HStack{
            Button{
                dismiss()
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
