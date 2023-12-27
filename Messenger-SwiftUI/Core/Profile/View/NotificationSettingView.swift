//
//  NotificationSettingView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 27/12/2023.
//

import SwiftUI
import Combine

struct NotificationSettingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel = NotificationSettingViewModel()
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.text)
                
                Text("Notifications")
                    .font(.semibold(size: 16))
                    .foregroundStyle(.text)
            }
            .hAlign(.leading)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.pop()
            }
            .padding(.bottom, 20)
            
            if viewModel.isNotificationEnabled{
                Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                    .tint(.blue)
                
                Text("If you turn off notifications you will not receive message notifications from friends")
                    .font(.regular(size: 13))
                    .padding(.vertical,5)
                    .foregroundStyle(.text)
                    .hAlign(.leading)
                
            }else{
                VStack(spacing: 6){
                    Text("Please allow notifications in this app.")
                        .font(.medium(size: 14))
                        .foregroundStyle(.text)
                        .hAlign(.center)
                    
                    Text("Click here")
                        .font(.bold(size: 13))
                        .foregroundStyle(.blue)
                        .hAlign(.center)
                }
                .padding(.top,3)
                .onTapGesture {
                    viewModel.openAppSettings()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationSettingView()
}
