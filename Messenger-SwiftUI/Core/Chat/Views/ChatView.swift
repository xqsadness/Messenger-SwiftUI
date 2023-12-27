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
    
    var lastMesage: Message?{
        let currentId = UserService.shared.currentUser?.id
        return viewModel.message.filter({ $0.toId == currentId }).last ?? nil
    }
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    @State private var scrollId: String = ""
    
    var body: some View {
        VStack{
            title
            
            ScrollView(showsIndicators: false){
                //header
                header
                
                //messages
                VStack{
                    ForEach(viewModel.message.reversed()){ message in
                        ChatMessageCell(message: message,viewModel: viewModel)
                    }
                }
                .scrollTargetLayout()
                .scrollDismissesKeyboard(.never)
            }
            .scrollPosition(id: .constant(viewModel.scrolledID?.id), anchor: .bottom)
            .refreshable {
                withAnimation {
                    viewModel.loadMoreMessages()
                }
            }

            //message input
            Spacer()
            
            messageInput
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                if lastMesage?.unread == true{
                    viewModel.updateUnreadMessage(lastMesage: lastMesage)
                }
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
                .onTapGesture {
                    dismiss()
                    viewModel.scrolledID = viewModel.message.last
                }
        }
        .hAlign(.leading)
        .padding(.horizontal)
        .overlay{
            Text(user.fullname)
                .font(.semibold(size: 20))
                .foregroundStyle(.text)
        }
        .padding(.bottom,8)
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
                .font(.regular(size: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.5)
                        .stroke(Color.text.opacity(0.3), lineWidth: 0.7)
                )
            
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
            .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false)
            .opacity(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
        }
        .padding(.horizontal)
        .padding(.bottom, focusedField != nil ? 7 : 0)
    }
}
