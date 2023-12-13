//
//  Messenger_SwiftUIApp.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI
import SwiftData

@main
struct InstagramApp: App {
    @StateObject var coordinator = Coordinator.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                Group{
                    ContentView()
                }
                .environmentObject(coordinator)
                .navigationBarHidden(true)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .navigationDestination(for: User.self) { user in
                    ProfileView(user: user)
                        .navigationBarBackButtonHidden()
                        .environmentObject(Coordinator.shared)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreencover in
                    coordinator.build(fullScreenCover: fullScreencover)
                }
            }
        }
    }
}

