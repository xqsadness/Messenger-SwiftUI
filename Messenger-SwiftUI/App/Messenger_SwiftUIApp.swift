//
//  Messenger_SwiftUIApp.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct InstagramApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

