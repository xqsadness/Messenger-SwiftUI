//
//  RootView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import SwiftUI

struct RootView: View{
    @StateObject var coordinator = Coordinator.shared
    @StateObject var appController = AppController.instance
    
    var body: some View{
        NavigationStack(path: $coordinator.path) {
            Group{
                ContentView()
            }
            .environmentObject(coordinator)
            .navigationBarHidden(true)
            //navigation 
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
            .navigationDestination(for: Route.self) { route in
                switch route{
                case .profile(_):
                    ProfileView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(Coordinator.shared)
                case .chatView(let user):
                    ChatView(user: user)
                        .navigationBarBackButtonHidden()
                        .environmentObject(Coordinator.shared)
                }
            }
            .navigationDestination(for: Message.self) { message in
                if let user = message.user{
                    ChatView(user: user)
                        .navigationBarBackButtonHidden()
                        .environmentObject(Coordinator.shared)
                }
            }
            .sheet(item: $coordinator.sheet) { sheet in
                coordinator.build(sheet: sheet)
            }
            .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreencover in
                coordinator.build(fullScreenCover: fullScreencover)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PushMessage"))) { (output) in
            DispatchQueue.main.async {
                guard let str = output.userInfo?["data"] as? String else {return}
                
                appController.MESSAGE_ON_SCREEN = str
                withAnimation(.easeInOut(duration: 1)) {
                    appController.SHOW_MESSAGE_ON_SCREEN  = true
                }
                appController.TIMER_MESSAGE_ON_SCREEN?.invalidate()
                appController.TIMER_MESSAGE_ON_SCREEN = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                    withAnimation(.easeInOut(duration: 1)){
                        appController.SHOW_MESSAGE_ON_SCREEN  = false
                    }
                })
            }
        }
        .overlay(alignment: .bottom, content: {
            appController.SHOW_MESSAGE_ON_SCREEN ?
            NotificationView()
            : nil
        })
    }
}
