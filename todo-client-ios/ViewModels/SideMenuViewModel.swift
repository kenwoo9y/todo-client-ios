import SwiftUI

class SideMenuViewModel: ObservableObject {
    @Published var isShowingSideMenu = false
    
    func toggleSideMenu() {
        isShowingSideMenu.toggle()
    }
} 