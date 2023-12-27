
import Foundation
import SwiftUI

enum Page: String, Identifiable{
    case NONE, loginView, registrationView, forgotPasswordView, notificationSettingView
    
    var id: String{
        return self.rawValue
    }
}

enum Sheet: String, Identifiable{
    case NONE
    var id: String{
        return self.rawValue
    }
}

enum FullScreenCover: String, Identifiable{
    case mewMessageView
    
    var id: String{
        return self.rawValue
    }
}

class Coordinator: ObservableObject{
    static var shared = Coordinator()
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ page: Page){
        path.append(page)
    }
    
    func presentSheet(_ sheet: Sheet){
        self.fullScreenCover = nil
        self.sheet = sheet
    }
    
    func presentFullScreen(_ fullScreenCover: FullScreenCover){
        self.sheet = nil
        self.fullScreenCover = fullScreenCover
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
    
    func dismissSheet(){
        self.sheet = nil
    }
    
    func dissmissFullscreenCover(){
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: Page) -> some View{
        switch page{
        case .loginView:
            LoginView()
                .navigationBarBackButtonHidden()
                .environmentObject(Coordinator.shared)
            
        case .registrationView:
            RegistrationView()
                .navigationBarBackButtonHidden()
                .environmentObject(Coordinator.shared)
            
        case .forgotPasswordView:
            ForgotPasswordView()
                .navigationBarBackButtonHidden()
                .environmentObject(Coordinator.shared)
            
        case .notificationSettingView:
            NotificationSettingView()
                .navigationBarBackButtonHidden()
                .environmentObject(Coordinator.shared)
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet, isRemoveBackground: Bool = false ,dentents: Set<PresentationDetent> = [.large]) -> some View{
        switch sheet{
        default:
            EmptyView()
                .background(isRemoveBackground ? RemoveBackground() : .init())
                .presentationDetents(dentents)
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View{
        switch fullScreenCover{
            
        default:
            EmptyView()
        }
    }
}

struct RemoveBackground: UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
