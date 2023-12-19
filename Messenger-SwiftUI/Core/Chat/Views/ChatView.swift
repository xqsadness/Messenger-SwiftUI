//
//  ChatView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct ChatView: View {
    enum FocusedField {
        case textInput
    }
    
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ChatViewModel
    
    @FocusState private var focusedField: FocusedField?
    
    let user: User
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack{
            title
            
            ScrollView(showsIndicators: false){
                //header
                header
                
                //messages
                LazyVStack{
                    ForEach(viewModel.message){ message in
                        ChatMessageCell(message: message)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: .constant(viewModel.scrolledID?.id), anchor: .bottom)
            
            //message input
            Spacer()
            
            messageInput
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                viewModel.scrolledID = viewModel.message.last
            }
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}

extension ChatView{
    private var title: some View{
        HStack{
            Image(systemName: "chevron.left")
                .imageScale(.medium)
                .foregroundStyle(.text)
            
            Text("Back")
                .font(.semibold(size: 14.5))
                .foregroundStyle(.text)
        }
        .hAlign(.leading)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .overlay{
            Text(user.fullname)
                .font(.semibold(size: 20))
                .foregroundStyle(.text)
        }
        .padding(.bottom,8)
        .onTapGesture {
            viewModel.scrolledID = nil
            dismiss()
        }
    }
    
    private var header: some View{
        VStack{
            CircularProfileImageView(user: user, size: .xLarge)
            
            VStack(spacing: 4){
                Text(user.fullname)
                    .font(.semibold(size: 17))
                    .foregroundStyle(.text)
                
                Text("Messenger")
                    .font(.regular(size: 13.5))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.bottom)
    }
    
    private var messageInput: some View{
        ZStack(alignment: .trailing){
            TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                .focused($focusedField, equals: .textInput)
                .padding(12)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.regular(size: 14))
            
            Button{
                viewModel.sendMessage()
                withAnimation {
                    viewModel.scrolledID = viewModel.message.last
                }
                viewModel.messageText = ""
                focusedField = nil
            }label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.blue)
                    .imageScale(.medium)
            }
            .padding(.horizontal)
            .disabled(viewModel.messageText.isEmpty ? true : false)
            .opacity(viewModel.messageText.isEmpty ? 0.4 : 1)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
