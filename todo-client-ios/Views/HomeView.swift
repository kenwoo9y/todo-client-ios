import SwiftUI

struct HomeView: View {
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // メインコンテンツ
                CommonLayout(isShowingSideMenu: $sideMenuViewModel.isShowingSideMenu) {
                    VStack {
                        // ここにメインコンテンツを配置
                        Text("Main Content")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    }
                }
                
                // サイドメニュー
                SideMenuView(isShowing: $sideMenuViewModel.isShowingSideMenu)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}